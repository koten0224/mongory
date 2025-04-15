# frozen_string_literal: true

module Mongory
  module Matchers
    # FieldMatcher is responsible for extracting a value from a record
    # using a field (or index) and then delegating the match to LiteralMatcher logic.
    #
    # It handles nested access in structures like Hashes or Arrays, and guards
    # against types that should not be dig into (e.g., String, Symbol, Proc).
    #
    # This matcher is typically used when the query refers to a specific field,
    # like `{ age: { :$gte => 18 } }` where `:age` is passed as the dig field.
    #
    # @example
    #   matcher = FieldMatcher.build(:age, { :$gte => 18 })
    #   matcher.match?({ age: 20 }) #=> true
    #
    # @see LiteralMatcher
    class FieldMatcher < LiteralMatcher
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

      # Initializes the matcher with a target field and condition.
      #
      # @param field [Object] the field (or index) used to dig into the record
      # @param condition [Object] the condition to match against the extracted value
      def initialize(field, condition)
        @field = field
        super(condition)
      end

      # Matches the record by extracting the value via field and applying the condition.
      #
      # @param record [Object] the record to match
      # @return [Boolean] whether the extracted value matches the condition
      def match(record)
        return false if record == KEY_NOT_FOUND

        super(Mongory.data_converter.convert(dig_value(record)))
      end

      # @return [String] a deduplication field used for matchers inside multi-match constructs
      # @see AbstractMultiMatcher#matchers
      def uniq_key
        super + "field:#{@field}"
      end

      private

      # Returns a single-line summary of the dig matcher including the field and condition.
      #
      # @return [String]
      def tree_title
        "Field: #{@field.inspect} to match: #{@condition.inspect}"
      end

      # Extracts a field value from the given record.
      # Supports fallback access for both string and symbol keys in hashes.
      # Returns `KEY_NOT_FOUND` if the key is missing or extraction fails.
      #
      # @param record [Object] the input document or array
      # @return [Object] the extracted value or KEY_NOT_FOUND
      def dig_value(record)
        case record
        when Hash
          record.fetch(@field) do
            record.fetch(@field.to_sym, KEY_NOT_FOUND)
          end
        when Array
          record.fetch(@field, KEY_NOT_FOUND)
        when KEY_NOT_FOUND, *CLASSES_NOT_ALLOW_TO_DIG
          KEY_NOT_FOUND
        else
          return KEY_NOT_FOUND unless record.respond_to?(:[])

          record[@field]
        end
      end

      # Custom display logic for debugging, including colored field highlighting.
      #
      # @param record [Object] the input record
      # @param result [Boolean] match result
      # @return [String] formatted debug string
      def display(record, result)
        result = result ? "\e[30;42mMatched\e[0m" : "\e[30;41mDismatch\e[0m"

        "#{self.class} => " \
          "result: #{result}, " \
          "condition: #{@condition.inspect}, " \
          "\e[30;47mkey: #{@field.inspect}\e[0m, " \
          "record: #{record.inspect.gsub(@field.inspect, "\e[30;47m#{@field.inspect}\e[0m")}"
      end
    end
  end
end
