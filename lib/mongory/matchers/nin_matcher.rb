# frozen_string_literal: true

module Mongory
  module Matchers
    # NinMatcher implements the `$nin` (not in) operator.
    #
    # It returns true if *none* of the record's values appear in the condition array.
    #
    # The record is cast to an array to ensure uniform behavior across types.
    #
    # This matcher is the logical opposite of InMatcher.
    #
    # @example
    #   matcher = NinMatcher.build([1, 2, 3])
    #   matcher.match?(4)        #=> true
    #   matcher.match?(2)        #=> false
    #   matcher.match?([4, 5])   #=> true
    #   matcher.match?([2, 4])   #=> false
    #
    # @see AbstractMatcher
    class NinMatcher < AbstractMatcher
      # Matches true if the record has no elements in common with the condition array.
      #
      # @param record [Object] the value to be tested
      # @return [Boolean] whether the record is disjoint from the condition array
      def match(record)
        is_blank?(@condition & Array(record))
      end

      # Ensures the condition is a valid array.
      #
      # @raise [TypeError] if the condition is not an array
      # @return [void]
      def check_validity!
        raise TypeError, '$nin needs an array' unless @condition.is_a?(Array)
      end
    end
  end
end
