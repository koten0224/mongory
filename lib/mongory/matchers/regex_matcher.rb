# frozen_string_literal: true

module Mongory
  module Matchers
    # RegexMatcher implements the `$regex` operator.
    # 
    # It returns true if the record string matches the given pattern string.
    #
    # Although `@condition` is passed as a string (due to ValueConverter converting
    # Regexp into its `source`), Ruby's `String#match?(String)` internally treats it
    # as a regular expression pattern. This allows direct use without explicit Regexp.new.
    #
    # This matcher ensures the record is a String before attempting the match.
    #
    # @example
    #   matcher = RegexMatcher.build('^foo')
    #   matcher.match?('foobar')   #=> true
    #   matcher.match?('barfoo')   #=> false
    #
    # @note `@condition` is a pattern string, not a full Regexp object.
    # @see AbstractOperatorMatcher
    # @see Mongory::Converters::ValueConverter
    class RegexMatcher < AbstractOperatorMatcher
      # Uses `:match?` as the operator to invoke on the record string.
      #
      # @return [Symbol] the match? method symbol
      def operator
        :match?
      end

      # Ensures the record is a string before applying regex.
      # If not, coerces to empty string to ensure match fails safely.
      #
      # @param record [Object] the raw input
      # @return [String] a safe string to match against
      def preprocess(record)
        return '' unless record.is_a?(String)

        record
      end

      # Ensures the condition is a valid string (not a Regexp).
      #
      # @raise [TypeError] if condition is not a string
      # @return [void]
      def check_validity!
        raise TypeError, '$regex needs a string' unless @condition.is_a?(String)
      end
    end
  end
end
