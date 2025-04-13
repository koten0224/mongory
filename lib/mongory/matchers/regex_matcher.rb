# frozen_string_literal: true

module Mongory
  module Matchers
    # RegexMatcher implements the `$regex` operator.
    #
    # It matches the given string against a regular expression pattern.
    # The condition may be a String or a Regexp.
    # If given a String, it is converted to a Regexp via `Regexp.new`.
    #
    # This allows both case-sensitive and case-insensitive usage:
    #
    # @example Case-sensitive
    #   matcher = RegexMatcher.build("foo")
    #   matcher.match?("foobar")   #=> true
    #   matcher.match?("FOOBAR")   #=> false
    #
    # @example Case-insensitive
    #   matcher = RegexMatcher.build(/foo/i)
    #   matcher.match?("FOOBAR")   #=> true
    #
    # @note Strings are converted to Regexp during initialization
    # @see AbstractOperatorMatcher
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

      # Ensures the condition is a Regexp (strings are converted during initialization).
      #
      # @raise [TypeError] if condition is not a string
      # @return [void]
      def check_validity!
        return if @condition.is_a?(Regexp)
        return if @condition.is_a?(String)

        raise TypeError, '$regex needs a Regexp or string'
      end
    end
  end
end
