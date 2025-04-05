# frozen_string_literal: true

require_relative 'utils'

module Mongory
  # Temp Description
  class QueryMatcher
    include Mongory::Utils

    def initialize(condition)
      @condition = deep_convert(condition.__expand_complex__)
    end

    def match?(record)
      default_matcher.match?(normalize_record(record))
    end

    def normalize_record(record)
      return record.send(data_converter) if data_converter.is_a?(Symbol) && record.respond_to?(data_converter)
      return data_converter.call(record) if data_converter.is_a?(Proc)

      deep_convert(record)
    end

    define_instance_cache_method(:default_matcher) do
      Mongory::Matchers::DefaultMatcher.new(@condition)
    end

    define_instance_cache_method(:data_converter) do
      Mongory.config.data_converter
    end
  end
end
