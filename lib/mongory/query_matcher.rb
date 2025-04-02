# frozen_string_literal: true

require 'mongory/utils'

module Mongory
  # Temp Description
  class QueryMatcher
    include Mongory::Utils

    def initialize(condition)
      @condition = deep_convert(condition.__expand_complex__)
    end

    def match?(record)
      main_matcher.match?(normalize_record(record))
    end

    def normalize_record(record)
      return record.as_json if record.respond_to?(:as_json)

      deep_convert(record)
    end

    define_instance_cache_method(:main_matcher) do
      Mongory::Matchers::MainMatcher.new(@condition)
    end
  end
end
