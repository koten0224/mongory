# frozen_string_literal: true

module Mongory
  # Temp Description
  class QueryBuilder
    include ::Enumerable

    def initialize(records)
      @records = Mongory::Utils.deep_convert(records)
    end

    def each(&block)
      @records.each(&block)
    end

    def where(condition)
      filter_and_return_new(condition)
    end

    def or(*conditions)
      filter_and_return_new('$or' => conditions)
    end

    def and(*conditions)
      filter_and_return_new('$and' => conditions)
    end

    def not(condition)
      filter_and_return_new('$not' => condition)
    end

    def asc(*keys)
      order_by_fields(*keys, direction: :asc)
    end

    def desc(*keys)
      order_by_fields(*keys, direction: :desc)
    end

    def limit(count)
      Mongory::QueryBuilder.new(take(count))
    end

    def only(*fields)
      trimed = map do |record|
        record.slice(*fields.map(&:to_s))
      end
      Mongory::QueryBuilder.new(trimed)
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

    def filter_and_return_new(condition)
      matcher = Mongory::QueryMatcher.new(condition)
      matched = select { |r| matcher.match?(r) }
      Mongory::QueryBuilder.new(matched)
    end

    def order_by_fields(*keys, direction: :asc)
      sorted = sort_by { |record| keys.map { |key| record[key.to_s] || nil } }
      sorted.reverse! if direction == :desc
      Mongory::QueryBuilder.new(sorted)
    end
  end
end
