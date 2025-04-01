# frozen_string_literal: true

require 'mongory/utils'

module Mongory
  # Temp Description
  class QueryMatcher
    include Mongory::Utils

    def initialize(condition)
      @condition = deep_convert(condition.__expand_complex__)
    end

    def match?(data)
      matcher.match?(deep_convert(data))
    end

    private

    def matcher
      return @matcher if defined?(@matcher)

      @matcher = Mongory::Matchers::MainMatcher.new(@condition)
    end
  end
end
