# frozen_string_literal: true

module Mongory
  module Matchers
    # OrMatcher implements the `$or` logical operator.
    # It evaluates an array of subconditions and returns true
    # if *any one* of them matches.
    #
    # Each subcondition is handled by a ConditionMatcher with conversion disabled,
    # since the parent matcher already manages data conversion.
    #
    # This matcher inherits submatcher dispatch and evaluation logic
    # from AbstractMultiMatcher.
    #
    # @example
    #   matcher = OrMatcher.build([
    #     { age: { :$lt => 18 } },
    #     { admin: true }
    #   ])
    #   matcher.match?(record) #=> true if either condition matches
    #
    # @see AbstractMultiMatcher
    class OrMatcher < AbstractMultiMatcher
      # Constructs a ConditionMatcher for each subcondition.
      # Conversion is disabled to avoid double-processing.
      singleton_class.alias_method :build, :dispatch

      # @see ConditionMatcher
      # @param condition [Object] a subcondition to be wrapped
      # @return [ConditionMatcher] a matcher for this condition
      def build_sub_matcher(condition)
        ConditionMatcher.build(condition, ignore_convert: true)
      end

      # Uses `:any?` to return true if any submatcher passes.
      #
      # @return [Symbol] the combining operator
      def operator
        :any?
      end

      # Optionally applies preprocessing unless disabled.
      #
      # @param record [Object] the record to be matched
      # @return [Object] the converted or raw record
      def preprocess(record)
        return record if @ignore_convert

        Mongory.data_converter.convert(record)
      end

      # Ensures the condition is an array of subconditions.
      #
      # @raise [TypeError] if condition is not an array
      # @return [void]
      def check_validity!
        raise TypeError, '$or needs an array' unless @condition.is_a?(Array)

        @condition.each do |sub_condition|
          raise TypeError, '$or needs an array of hash' unless sub_condition.is_a?(Hash)
        end
      end
    end
  end
end
