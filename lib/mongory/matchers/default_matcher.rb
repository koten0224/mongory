# frozen_string_literal: true

module Mongory
  module Matchers
    # DefaultMatcher is the main entry point of Mongory's matcher pipeline.
    #
    # It delegates matching to more specific matchers depending on the shape
    # of the given condition and record.
    #
    # The dispatching rules are:
    # - If condition == record, returns true (exact match)
    # - If record is an Array, dispatches to CollectionMatcher
    # - If condition is a Hash, dispatches to ConditionMatcher
    # - If condition is a Regexp, applies `Regexp#match?` to the record
    # - Otherwise, returns false
    #
    # This allows support for queries like `{ name: /admin/i }` or `$not => /regex/`
    # to be handled naturally without needing operator dispatch.
    # @example
    #   matcher = DefaultMatcher.build({ age: { :$gte => 30 } })
    #   matcher.match(record) #=> true or false
    #
    # @see AbstractMatcher
    class DefaultMatcher < AbstractMatcher
      # Matches the given record against the stored condition.
      # The logic dynamically chooses the appropriate sub-matcher.
      # @param condition [Object] the raw condition
      def initialize(condition, *)
        @condition_is_hash = condition.is_a?(Hash)
        @condition_is_regex = condition.is_a?(Regexp)
        super
      end

      # Matches the given record against the condition.
      #
      # @param record [Object] the record to be matched
      # @return [Boolean] whether the record satisfies the condition
      def match(record)
        if @condition == record
          true
        elsif record.is_a?(Array)
          collection_matcher.match?(record)
        elsif @condition_is_hash
          condition_matcher.match?(record)
        elsif @condition_is_regex
          return false unless record.is_a?(String)

          @condition.match?(record)
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

      # Validates the nested condition matcher, if applicable.
      #
      # @return [void]
      def deep_check_validity!
        condition_matcher.deep_check_validity! if @condition_is_hash
      end

      # Outputs the matcher tree by selecting either collection or condition matcher.
      # Delegates `render_tree` to whichever submatcher was active.
      #
      # @param pp [PP]
      # @param prefix [String]
      # @param is_last [Boolean]
      # @return [void]
      def render_tree(pp, prefix = '', is_last: true)
        super

        new_prefix = "#{prefix}#{is_last ? '   ' : '│  '}"
        if @collection_matcher
          @collection_matcher.render_tree(pp, new_prefix, is_last: true)
        elsif @condition_is_hash
          condition_matcher.render_tree(pp, new_prefix, is_last: true)
        end
      end
    end
  end
end
