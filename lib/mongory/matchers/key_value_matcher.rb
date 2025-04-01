# frozen_string_literal: true

require 'mongory/matchers/base_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class KeyValueMatcher < BaseMatcher
      def initialize(match_key, match_value)
        @match_key = match_key
        @match_value = match_value
      end

      def match?(record)
        return operator_matcher.match?(record) if operator_matcher

        sub_value = fetch_value(record, @match_key)

        if record.is_a?(Array) && sub_value == KEY_NOT_FOUND
          elem_matcher.match?(record)
        else
          main_matcher.match?(sub_value)
        end
      end

      def operator_matcher
        return @operator_matcher if defined?(@operator_matcher)

        @operator_matcher = Matchers.operator_lookup(@match_key)&.new(@match_value)
      end

      def elem_matcher
        return @elem_matcher if defined?(@elem_matcher)

        @elem_matcher = ElemMatchMatcher.new(@match_key => @match_value)
      end

      def main_matcher
        return @main_matcher if defined?(@main_matcher)

        @main_matcher = MainMatcher.new(@match_value)
      end
    end
  end
end
