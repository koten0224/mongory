# frozen_string_literal: true

module Mongory
  module Matchers
    # EveryMatcher implements the logic for Mongo-style `$every` which is not really support in MongoDB.
    # It is used to determine if *all* element in an array matches the given condition.
    #
    # This matcher delegates element-wise comparison to ConditionMatcher,
    # allowing nested conditions to be applied recursively.
    #
    # @example
    #   matcher = EveryMatcher.build({ status: 'active' })
    #   matcher.match?([{ status: 'inactive' }, { status: 'active' }]) #=> false
    #
    # @see ConditionMatcher
    class EveryMatcher < ConditionMatcher
      # Matches true if all element in the array satisfies the condition.
      # Falls back to false if the input is not an array.
      singleton_class.alias_method :build, :new

      # @param collection [Object] the input to be tested
      # @return [Boolean] whether all element matches
      def match(collection)
        return false unless collection.is_a?(Array)

        collection.all? do |record|
          super(Mongory.data_converter.convert(record))
        end
      end

      def check_validity!
        raise TypeError, '$every needs a Hash.' unless @condition.is_a?(Hash)
      end
    end
  end
end
