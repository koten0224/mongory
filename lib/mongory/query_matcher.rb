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
      main_matcher.match?(deep_convert(record))
    end

    def main_matcher
      return @main_matcher if defined?(@main_matcher)

      @main_matcher = Mongory::Matchers::MainMatcher.new(@condition)
    end
  end
end
