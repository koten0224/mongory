# frozen_string_literal: true

require 'mongory/utils'

module Mongory
  # Temp Description
  class QueryBuilder
    include ::Enumerable
    include Mongory::Utils

    def initialize(records)
      @records = records
      @matchers = []
    end

    def each(&block)
      result.each(&block)
    end

    def where(condition)
      condition_chain(condition)
    end

    def or(*conditions)
      condition_chain('$or' => conditions)
    end

    def and(*conditions)
      condition_chain('$and' => conditions)
    end

    def not(condition)
      condition_chain('$not' => condition)
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

    def condition_chain(condition)
      dup_instance_exec do
        @matchers += [Mongory::QueryMatcher.new(condition).main_matcher]
      end
    end

    def order_by_fields(*keys, direction: :asc)
      dup_instance_exec do
        @sort_keys = keys
        @sort_direction = direction
      end
    end

    def dup_instance_exec(&block)
      dup.tap do |obj|
        obj.instance_exec(&block)
      end
    end

    def result
      res = @records.select do |r|
        r = deep_convert(r)
        @matchers.all? { |m| m.match?(r) }
      end

      @matchers.each(&:clear)

      if @sort_keys
        res.sort_by! { |record| @sort_keys.map { |key| record[key.to_s] || nil } }
        res.reverse! if @sort_direction == :desc
      end

      res = res.take(@limit) if @limit
      res
    end
  end
end
