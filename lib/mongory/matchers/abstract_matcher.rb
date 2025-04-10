# frozen_string_literal: true

module Mongory
  module Matchers
    # AbstractMatcher is the base class for all matchers in Mongory.
    # It defines a common interface (`#match?`) and provides shared behavior
    # such as condition storage, optional conversion handling, and debugging output.
    #
    # Subclasses are expected to implement `#match(record)` to define their matching logic.
    # This class also supports caching of lazily-built matchers via `define_matcher`.
    #
    # @abstract
    class AbstractMatcher
      include Utils

      singleton_class.alias_method :build, :new
      # Sentinel value used to represent missing keys when traversing nested hashes.
      KEY_NOT_FOUND = SingletonBuilder.new('KEY_NOT_FOUND')

      # Defines a lazily-evaluated matcher accessor with instance-level caching.
      #
      # @param name [Symbol] the name of the matcher (e.g., :collection)
      # @yield the block that constructs the matcher instance
      # @return [void]
      def self.define_matcher(name, &block)
        define_instance_cache_method(:"#{name}_matcher", &block)
      end

      # @return [Object] the raw condition this matcher was initialized with
      attr_reader :condition

      # Initializes the matcher with a condition and optional conversion control.
      #
      # @param condition [Object] the condition to match against
      def initialize(condition)
        @condition = condition

        check_validity!
      end

      # Performs the actual match logic.
      # Subclasses must override this method.
      #
      # @param record [Object] the input record to test
      # @return [Boolean] whether the record matches the condition
      def match(*); end

      # Wrapper for `#match` with clearer semantics.
      #
      # @param record [Object] the input record to test
      # @return [Boolean] whether the record matches the condition
      def match?(record)
        match(record)
      end

      # Provides an alias to `#match?` for internal delegation.
      alias_method :regular_match, :match?

      # Evaluates the match with debugging output.
      # Increments indent level and prints visual result with colors.
      #
      # @param record [Object] the input record to test
      # @return [Boolean] whether the match succeeded
      def debug_match(record)
        Debugger.indent_level += 1
        result = match(record)
        puts (' ' * Debugger.indent_level * 2) + display(record, result)
        result
      rescue Exception
        Debugger.indent_level = 1
        raise
      ensure
        Debugger.indent_level -= 1
      end

      private

      # Hook for subclasses to validate the given condition.
      # Default is no-op. Should raise if condition is malformed.
      #
      # @return [void]
      def check_validity!; end

      def deep_check_validity!
        check_validity!
      end

      # Normalizes a potentially missing record value.
      # Converts sentinel `KEY_NOT_FOUND` to nil.
      #
      # @param record [Object] the input value
      # @return [Object, nil] the normalized value
      def normalize(record)
        record == KEY_NOT_FOUND ? nil : record
      end

      # Formats a debug string for match output.
      # Uses ANSI escape codes to highlight matched vs. mismatched records.
      #
      # @param record [Object] the record being tested
      # @param result [Boolean] whether the match succeeded
      # @return [String] the formatted output string
      def display(record, result)
        result = result ? "\e[30;42mMatched\e[0m" : "\e[30;41mDismatch\e[0m"

        "#{self.class} => " \
          "result: #{result}, " \
          "condition: #{@condition.inspect}, " \
          "record: #{record.inspect}"
      end
    end
  end
end
