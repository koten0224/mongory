# frozen_string_literal: true

module Mongory
  module Matchers
    # DigValueMatcher is responsible for extracting a value from a record
    # using a key (or index) and then delegating the match to DefaultMatcher logic.
    #
    # It handles nested access in structures like Hashes or Arrays, and guards
    # against types that should not be dig into (e.g., String, Symbol, Proc).
    #
    # This matcher is typically used when the query refers to a specific field,
    # like `{ age: { :$gte => 18 } }` where `:age` is passed as the dig key.
    #
    # @example
    #   matcher = DigValueMatcher.build(:age, { :$gte => 18 })
    #   matcher.match?({ age: 20 }) #=> true
    #
    # @see DefaultMatcher
    class DigValueMatcher < DefaultMatcher
      # A list of classes that should never be used for value digging.
      # These typically respond to `#[]` but are semantically invalid for this context.
      CLASSES_NOT_ALLOW_TO_DIG = [
        ::String,
        ::Integer,
        ::Proc,
        ::Method,
        ::MatchData,
        ::Thread,
        ::Symbol
      ].freeze

      # @param key [Object] the key (or index) used to dig into the record
      # @param condition [Object] the condition to match against the extracted value
      def initialize(key, condition)
        @key = key
        super(condition)
      end

      # Extracts the target value using the key and delegates to DefaultMatcher.
      #
      # @param record [Object] the record to match
      # @return [Boolean] whether the extracted value matches the condition
      def match(record)
        super(dig_value(record))
      end

      private

      # Attempts to extract the value from the given record using @key.
      # Guards against unsupported types and returns KEY_NOT_FOUND if extraction fails.
      #
      # @param record [Object] the input record
      # @return [Object] the extracted value or KEY_NOT_FOUND
      def dig_value(record)
        case record
        when Hash, Array
          record.fetch(@key, KEY_NOT_FOUND)
        when KEY_NOT_FOUND, *CLASSES_NOT_ALLOW_TO_DIG
          KEY_NOT_FOUND
        else
          return KEY_NOT_FOUND unless record.respond_to?(:[])

          record[@key]
        end
      end

      # Custom display logic for debugging, including colored key highlighting.
      #
      # @param record [Object] the input record
      # @param result [Boolean] match result
      # @return [String] formatted debug string
      def display(record, result)
        result = result ? "\e[30;42mMatched\e[0m" : "\e[30;41mDismatch\e[0m"

        "#{self.class} => " \
          "result: #{result}, " \
          "condition: #{@condition.inspect}, " \
          "\e[30;47mkey: #{@key.inspect}\e[0m, " \
          "record: #{record.inspect.gsub(@key.inspect, "\e[30;47m#{@key.inspect}\e[0m")}"
      end
    end
  end
end
