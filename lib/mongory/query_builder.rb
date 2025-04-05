# frozen_string_literal: true

require_relative 'utils'

module Mongory
  # Temp Description
  class QueryBuilder
    include ::Enumerable
    include Mongory::Utils

    def initialize(records)
      @records = records
      @condition = {}
    end

    def each(&block)
      result.each(&block)
    end

    def where(condition)
      self.and(condition)
    end

    def and(*conditions)
      dup_instance_exec do
        @condition['$and'] = Array(@condition['$and']) + conditions
      end
    end

    def or(*conditions)
      dup_instance_exec do
        @condition['$or'] = Array(@condition['$or']) + conditions
      end
    end

    def not(condition)
      self.and('$not' => condition)
    end

    def asc(*keys)
      order_by_fields(*keys, direction: :asc)
    end

    def desc(*keys)
      order_by_fields(*keys, direction: :desc)
    end

    def limit(count)
      dup_instance_exec do
        @limit = count
      end
    end

    def pluck(field, *fields)
      if fields.empty?
        map { |record| record[field.to_s] }
      else
        fields.unshift(field)
        map { |record| fields.map { |key| record[key.to_s] } }
      end
    end

    private

    def order_by_fields(*keys, direction: :asc)
      dup_instance_exec do
        @sort_keys = keys
        @sort_direction = direction
      end
    end

    def dup_instance_exec(&block)
      dup.tap do |obj|
        obj.instance_exec do
          @condition = @condition.dup
        end
        obj.instance_exec(&block)
      end
    end

    def result
      matcher = Mongory::QueryMatcher.new(@condition)
      res = @records.select do |r|
        matcher.match?(r)
      end

      if @sort_keys
        res.sort_by! { |record| @sort_keys.map { |key| record[key.to_s] || nil } }
        res.reverse! if @sort_direction == :desc
      end

      res = res.take(@limit) if @limit
      res
    end
  end
end
