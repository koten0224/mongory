# frozen_string_literal: true

require_relative 'utils'

module Mongory
  # QueryBuilder provides a Mongo-like in-memory query interface.
  #
  # It supports condition chaining (`where`, `or`, `not`),
  # sorting (`asc`, `desc`), limiting, and plucking fields.
  # Internally it compiles all conditions and invokes `QueryMatcher`.
  #
  # @example
  #   records.mongory
  #     .where(:age.gte => 18)
  #     .or({ :name => /J/ }, { :name.eq => "Bob" })
  #     .desc(:age)
  #     .limit(2)
  #     .to_a
  class QueryBuilder
    include ::Enumerable
    include Utils

    # @return [Hash] the raw compiled condition
    attr_reader :condition

    # @param records [Enumerable] the in-memory dataset to query
    def initialize(records)
      @records = records
      @condition = Hash.new { |h, k| h[k] = [] }
    end

    # Enumerates over filtered result set.
    #
    # @yieldparam record [Object] an item from the original enumerable
    # @return [Enumerator, void]
    def each(&block)
      return to_enum(:each) unless block_given?

      result.each(&block)
    end

    # Adds a condition using `$and`.
    #
    # @param condition [Hash]
    # @return [QueryBuilder] a new builder instance
    def where(condition)
      self.and(condition)
    end

    # Adds multiple `$and` conditions.
    #
    # @param conditions [Array<Hash>]
    # @return [QueryBuilder]
    def and(*conditions)
      dup_instance_exec do
        @condition['$and'] += conditions
      end
    end

    # Adds multiple `$or` conditions.
    #
    # @param conditions [Array<Hash>]
    # @return [QueryBuilder]
    def or(*conditions)
      dup_instance_exec do
        @condition['$or'] += conditions
      end
    end

    # Adds a `$not` wrapper to a condition.
    #
    # @param condition [Hash]
    # @return [QueryBuilder]
    def not(condition)
      self.and('$not' => condition)
    end

    # Sorts results by given keys ascendingly.
    #
    # @param keys [Array<Symbol, String>]
    # @return [QueryBuilder]
    def asc(*keys)
      order_by_fields(*keys, direction: :asc)
    end

    # Sorts results by given keys descendingly.
    #
    # @param keys [Array<Symbol, String>]
    # @return [QueryBuilder]
    def desc(*keys)
      order_by_fields(*keys, direction: :desc)
    end

    # Limits the number of records returned.
    #
    # @param count [Integer]
    # @return [QueryBuilder]
    def limit(count)
      dup_instance_exec do
        @limit = count
      end
    end

    # Extracts specific fields from each record.
    #
    # @param field [Symbol, String]
    # @param fields [Array<Symbol, String>]
    # @return [Array<Object>, Array<Array<Object>>]
    def pluck(field, *fields)
      if fields.empty?
        map { |record| record[field.to_s] }
      else
        fields.unshift(field)
        map { |record| fields.map { |key| record[key.to_s] } }
      end
    end

    private

    # Records sorting helper with direction.
    #
    # @param keys [Array<String, Symbol>]
    # @param direction [Symbol] :asc or :desc
    # @return [void]
    def order_by_fields(*keys, direction:)
      dup_instance_exec do
        @sort_keys = keys
        @sort_direction = direction
      end
    end

    # Duplicates the current instance and runs a block inside it.
    #
    # @yield a block executed in the context of the cloned object
    # @return [QueryBuilder]
    def dup_instance_exec(&block)
      dup.tap do |obj|
        obj.instance_exec(&block)
      end
    end

    # Performs deep dup of internal state for immutable chaining.
    #
    # @return [QueryBuilder]
    def dup
      super.tap do |obj|
        obj.instance_exec do
          @condition = @condition.dup
        end
      end
    end

    # Executes the actual query logic by evaluating the matcher.
    #
    # @return [Array<Object>] filtered results
    def result
      matcher = Mongory::QueryMatcher.new(@condition)
      res = @records.select { |r| matcher.match?(r) }

      if @sort_keys
        res.sort_by! { |record| @sort_keys.map { |key| record[key.to_s] } }
        res.reverse! if @sort_direction == :desc
      end

      res = res.take(@limit) if @limit
      res
    end
  end
end
