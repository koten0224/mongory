# frozen_string_literal: true

require 'mongory/matchers/abstract_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class KeyValueMatcher < AbstractMatcher
      def initialize(match_key, match_value)
        super(match_key => match_value)
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

      define_matcher(:operator) do
        Matchers.lookup(@match_key)&.new(@match_value)
      end

      define_matcher(:elem) do
        ElemMatchMatcher.new(@condition)
      end

      define_matcher(:main) do
        MainMatcher.new(@match_value)
      end

      private

      def fetch_value(record, key)
        case record
        when Hash
          record.fetch(key, KEY_NOT_FOUND)
        when Array
          return KEY_NOT_FOUND unless key.match?(/^\d+$/)

          record[key.to_i]
        end
      end
    end
  end
end
