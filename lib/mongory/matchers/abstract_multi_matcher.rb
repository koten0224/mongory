# frozen_string_literal: true

module Mongory
  module Matchers
    # AbstractMultiMatcher is an abstract base class for matchers that operate
    # on multiple subconditions. It provides a generic match loop that applies
    # a logical operator (e.g., `all?`, `any?`) over a list of sub-matchers.
    #
    # Subclasses must define two methods:
    #   - `#build_sub_matcher`: how to construct a matcher from each condition
    #   - `#operator`: which enumerator method to use (e.g., :all?, :any?)
    #
    # Sub-matchers are cached using `define_instance_cache_method` to prevent
    # repeated construction.
    #
    # @abstract
    # @see AbstractMatcher
    class AbstractMultiMatcher < AbstractMatcher
      # Enables auto-dispatch logic.
      # When used, `.build` may unwrap to first matcher if only one is present.
      #
      # @return [void]
      def self.dispatch!
        @dispatch = true
        singleton_class.alias_method :build, :dispatch
      end

      # Builds a matcher and conditionally unwraps it.
      #
      # @param args [Array] arguments passed to the constructor
      # @return [AbstractMatcher]
      def self.dispatch(*args)
        matcher = new(*args)
        return matcher unless @dispatch

        matcher = matcher.matchers.first if matcher.matchers.count == 1
        matcher
      end

      # Performs matching over all sub-matchers using the specified operator.
      # The input record may be preprocessed first (e.g., for normalization).
      #
      # @param record [Object] the record to match
      # @return [Boolean] whether the combined result of sub-matchers satisfies the condition
      def match(record)
        record = preprocess(record)
        matchers.send(operator) do |matcher|
          matcher.match?(record)
        end
      end

      # Lazily builds and caches the array of sub-matchers.
      # Subclasses provide the implementation of `#build_sub_matcher`.
      # Duplicate matchers (by condition) are removed to avoid redundancy.
      #
      # @return [Array<AbstractMatcher>] list of sub-matchers
      define_instance_cache_method(:matchers) do
        @condition.map(&method(:build_sub_matcher)).uniq(&:condition)
      end

      # Optional hook for subclasses to transform the input record before matching.
      # Default implementation returns the record unchanged.
      #
      # @param record [Object] the input record
      # @return [Object] the transformed or original record
      def preprocess(record)
        record
      end

      # Abstract method to define how each subcondition should be turned into a matcher.
      #
      # @param args [Array] the inputs needed to construct a matcher
      # @return [AbstractMatcher] a matcher instance for the subcondition
      def build_sub_matcher(*); end

      # Abstract method to specify the combining operator for sub-matchers.
      # Must return a valid enumerable method name (e.g., :all?, :any?).
      #
      # @return [Symbol] the operator method to apply over matchers
      def operator; end

      # Recursively checks all submatchers for validity.
      #
      # @return [void]
      def deep_check_validity!
        super
        matchers.each(&:deep_check_validity!)
      end
    end
  end
end
