# frozen_string_literal: true

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class DigValueMatcher < DefaultMatcher
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

      def initialize(key, condition)
        super(condition)
        @key = key
      end

      def match(record)
        super(dig_value(record))
      end

      private

      def dig_value(record)
        case record
        when Hash
          record.fetch(@key, KEY_NOT_FOUND)
        when Array
          record[@key]
        when KEY_NOT_FOUND, *CLASSES_NOT_ALLOW_TO_DIG
          KEY_NOT_FOUND
        else
          return KEY_NOT_FOUND unless record.respond_to?(:[])

          record[@key]
        end
      end

      def display(record, result)
        result = result ? "\e[30;42mMatched\e[0m" : "\e[30;41mDismatch\e[0m"

        "#{self.class} => " \
          "result: #{result}, " \
          "condition: #{@condition.inspect}, " \
          "key: #{@key.inspect}, " \
          "record: #{record.inspect}"
      end
    end
  end
end
