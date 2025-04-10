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
    #   matcher = AndMatcher.build([
    #     { age: { :$gte => 18 } },
    #     { status: "active" }
    #   ])
    #   matcher.match?(record) #=> true only if both conditions match
    #
    # @see AbstractMultiMatcher
    class AndMatcher < AbstractMultiMatcher
      # Constructs a ConditionMatcher for each subcondition.
      # Conversion is disabled to avoid double-processing.
      dispatch!

      # Builds a matcher for each subcondition using ConditionMatcher.
      #
      # @param condition [Hash] subcondition hash
      # @return [AbstractMatcher]
      def build_sub_matcher(condition)
        ConditionMatcher.build(condition)
      end

      # Combines submatcher results using `:all?`.
      #
      # @return [Symbol]
      def operator
        :all?
      end

      # Ensures the condition is an array of hashes.
      #
      # @raise [Mongory::TypeError] if not valid
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
