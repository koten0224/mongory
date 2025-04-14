# frozen_string_literal: true

module Mongory
  module Matchers
    # LiteralMatcher is responsible for handling raw literal values in query conditions.
    #
    # This matcher dispatches logic based on the type of the literal value,
    # such as nil, Array, Regexp, Hash, etc., and delegates to the appropriate specialized matcher.
    #
    # It is used when the query condition is a direct literal and not an operator or nested query.
    #
    # @example Supported usages
    #   { name: "Alice" }         # String literal
    #   { age: 18 }               # Numeric literal
    #   { active: true }          # Boolean literal
    #   { tags: [1, 2, 3] }       # Array literal → CollectionMatcher
    #   { email: /@gmail\\.com/i } # Regexp literal → RegexMatcher
    #   { info: nil }             # nil literal → nil_matcher (matches null or missing)
    #
    # @note This matcher is commonly dispatched from ConditionMatcher or FieldMatcher
    #       when the condition is a simple literal value, not an operator hash.
    #
    # === Supported literal types:
    # - String
    # - Integer / Float
    # - Symbol
    # - TrueClass / FalseClass
    # - NilClass → delegates to nil_matcher
    # - Regexp → delegates to RegexMatcher
    # - Array → delegates to CollectionMatcher
    # - Hash → delegates to ConditionMatcher (if treated as sub-query)
    # - Other unrecognized values → fallback to equality match (==)
    #
    # === Excluded types (handled by other matchers):
    # - Operator hashes like `{ "$gt" => 5 }` → handled by OperatorMatcher
    # - Nested paths like `"a.b.c"` → handled by FieldMatcher
    # - Query combinators like `$or`, `$and`, `$not` → handled by corresponding matchers
    #
    # @see Mongory::Matchers::RegexMatcher
    # @see Mongory::Matchers::OrMatcher
    # @see Mongory::Matchers::CollectionMatcher
    # @see Mongory::Matchers::ConditionMatcher
    class LiteralMatcher < AbstractMatcher
      # Matches the given record against the stored condition.
      # The logic dynamically chooses the appropriate sub-matcher.
      # @param condition [Object] the raw condition
      def initialize(condition, *)
        @condition_is_hash = condition.is_a?(Hash)
        @condition_is_regex = condition.is_a?(Regexp)
        @condition_is_nil = condition.nil?
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
          # If the condition is a Regexp, delegate to RegexMatcher for consistent matching logic.
          # This supports features like case-insensitive matching and .explain tracing.
          regex_matcher.match?(record)
        elsif @condition_is_nil
          nil_matcher.match?(record)
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

      # Lazily defines the regex matcher for Regexp conditions.
      # Used to delegate matching logic to RegexMatcher when @condition is a Regexp.
      #
      # This allows `LiteralMatcher` to handle queries like `{ field: /abc/i }`
      # by dispatching to a proper matcher class that supports explain and trace output.
      #
      # @see RegexMatcher
      # @return [RegexMatcher] the matcher used for regular expression comparison
      # @!method regex_matcher
      define_matcher(:regex) do
        RegexMatcher.build(@condition)
      end

      # Defines a matcher that checks if a field is either `nil` or does not exist.
      #
      # This matcher reflects MongoDB's behavior when querying with `{ field: nil }`,
      # which matches documents where the field value is explicitly `null` or the field is missing.
      #
      # Internally implemented as an `OrMatcher` that combines:
      # - `{ "$exists" => false }`
      # - `{ "$eq" => nil }`
      #
      # @return [OrMatcher] the matcher that handles `nil` equivalence in MongoDB
      # @see LiteralMatcher
      # @see Mongory::Matchers::OrMatcher
      # @!method nil_matcher
      define_matcher(:nil) do
        OrMatcher.build([
          { '$exists' => false },
          { '$eq' => nil }
        ])
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
        elsif @condition_is_regex
          regex_matcher.render_tree(pp, new_prefix, is_last: true)
        elsif @condition_is_nil
          nil_matcher.render_tree(pp, new_prefix, is_last: true)
        end
      end
    end
  end
end
