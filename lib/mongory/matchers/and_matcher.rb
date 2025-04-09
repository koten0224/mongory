# frozen_string_literal: true

module Mongory
  module Matchers
    # AndMatcher implements the `$and` logical operator.
    # It receives an array of subconditions and matches only if *all* of them succeed.
    # Each subcondition is dispatched through a ConditionMatcher, with conversion disabled
    # to avoid redundant processing.
    #
    # This matcher inherits the multi-condition matching logic from AbstractMultiMatcher
    # and defines its own strategy (`:all?`) and matcher construction.
    #
    # @example
    #   matcher = AndMatcher.new([
    #     { age: { :$gte => 18 } },
    #     { status: "active" }
    #   ])
    #   matcher.match?(record) #=> true only if both conditions match
    #
    # @see AbstractMultiMatcher
    class AndMatcher < AbstractMultiMatcher
      # Constructs a ConditionMatcher for each subcondition.
      # Conversion is disabled to avoid double-processing.
      #
      # @see ConditionMatcher
      # @param condition [Object] the raw subcondition
      # @return [ConditionMatcher] the matcher instance for the condition
      def build_sub_matcher(condition)
        ConditionMatcher.new(condition)
      end

      # Uses the `:all?` operator to ensure all subconditions must match.
      #
      # @return [Symbol] the combining operator
      def operator
        :all?
      end

      # Optionally preprocesses the input record using the data converter,
      # unless `@ignore_convert` is explicitly set.
      #
      # @param record [Object] the original input record
      # @return [Object] the preprocessed record
      def preprocess(record)
        return record if @ignore_convert

        Mongory.data_converter.convert(record)
      end

      # Validates that the condition is an Array.
      # Raises a TypeError if the input is malformed.
      #
      # @raise [TypeError] if condition is not an Array
      # @return [void]
      def check_validity!
        raise TypeError, '$and needs an array' unless @condition.is_a?(Array)

        @condition.each do |sub_condition|
          raise TypeError, '$and needs an array of hash' unless sub_condition.is_a?(Hash)
        end
      end
    end
  end
end
