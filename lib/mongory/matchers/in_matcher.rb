# frozen_string_literal: true

module Mongory
  module Matchers
    # InMatcher implements the `$in` operator.
    #
    # It checks whether the record (converted to an array) has any overlap
    # with the condition array. This supports both scalar and array inputs.
    #
    # The match succeeds if there is any intersection between the condition array
    # and the record value (or values).
    #
    # @example
    #   matcher = InMatcher.build([1, 2, 3])
    #   matcher.match?(2)        #=> true
    #   matcher.match?([3, 4])   #=> true
    #   matcher.match?(5)        #=> false
    #
    # @see AbstractMatcher
    class InMatcher < AbstractMatcher
      # Matches if any element of the record appears in the condition array.
      # Converts record to an array before intersecting.
      #
      # @param record [Object] the record value to test
      # @return [Boolean] whether any values intersect
      def match(record)
        is_present?(@condition & Array(record))
      end

      # Ensures the condition is an array.
      #
      # @raise [TypeError] if condition is not an array
      # @return [void]
      def check_validity!
        raise TypeError, '$in needs an array' unless @condition.is_a?(Array)
      end
    end
  end
end
