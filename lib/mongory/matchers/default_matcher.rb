# frozen_string_literal: true

module Mongory
  module Matchers
    # DefaultMatcher is the main entry point of Mongory's matcher pipeline.
    # It delegates matching to more specific matchers depending on the shape
    # of the given condition and record.
    #
    # The dispatching rules are:
    #   - If the condition equals the record (`==`), it's an exact match.
    #   - If the record is an Array, delegate to CollectionMatcher.
    #   - If the condition is a Hash, delegate to ConditionMatcher.
    #   - Otherwise, return false.
    #

    #
    # @example
    #   matcher = DefaultMatcher.build({ age: { :$gte => 30 } })
    #   matcher.match(record) #=> true or false
    #
    # @see AbstractMatcher
    class DefaultMatcher < AbstractMatcher
      # Matches the given record against the stored condition.
      # The logic dynamically chooses the appropriate sub-matcher.
      def initialize(condition, *)
        @condition_is_hash = condition.is_a?(Hash)
        super
      end

      # @param record [Object] the record to be matched
      # @return [Boolean] whether the record satisfies the condition
      def match(record)
        if @condition == record
          true
        elsif record.is_a?(Array)
          collection_matcher.match?(record)
        elsif @condition_is_hash
          condition_matcher.match?(record)
        else
          false
        end
      end

      # Lazily defines the collection matcher for array records.
      #
      # @see CollectionMatcher
      # @return [CollectionMatcher] the matcher used to match array-type records
      # @!method collection_matcher
      define_matcher(:collection) do
        CollectionMatcher.build(@condition)
      end

      # Lazily defines the condition matcher for hash conditions.
      # Conversion is disabled here to avoid redundant processing.
      #
      # @see ConditionMatcher
      # @return [ConditionMatcher] the matcher used for hash-based logic
      # @!method condition_matcher
      define_matcher(:condition) do
        ConditionMatcher.build(@condition)
      end

      def deep_check_validity!
        condition_matcher.deep_check_validity! if @condition_is_hash
      end
    end
  end
end
