# frozen_string_literal: true

require 'mongory/matchers/abstract_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class KeyValueMatcher < AbstractMatcher
      # These classes are not expected to dig value but respond to :[] method
      CLASSES_NOT_ALLOW_TO_DIG = [
        ::String,
        ::Integer,
        ::Proc,
        ::Method,
        ::MatchData,
        ::Thread,
        ::Symbol
      ].freeze

      def initialize(match_key, match_value)
        super(match_key => match_value)
        @match_key = match_key
        @match_value = match_value
      end

      def match?(record)
        return operator_matcher.match?(record) if operator_matcher

        main_matcher.match?(fetch_value(record))
      end

      define_matcher(:operator) do
        Matchers.lookup(@match_key)&.new(@match_value)
      end

      define_matcher(:main) do
        MainMatcher.new(@match_value)
      end

      private

      def fetch_value(record)
        case record
        when Hash
          record.fetch(@match_key, KEY_NOT_FOUND)
        when Array
          record[@match_key]
        when *CLASSES_NOT_ALLOW_TO_DIG
          KEY_NOT_FOUND
        else
          return KEY_NOT_FOUND unless record.respond_to?(:[])

          record[@match_key]
        end
      end
    end
  end
end
