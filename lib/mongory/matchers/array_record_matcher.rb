# frozen_string_literal: true

module Mongory
  module Matchers
    # ArrayRecordMatcher matches records where the record itself is an Array.
    #
    # This matcher checks whether any element of the record array satisfies the expected condition.
    # It is typically used when the record is a collection of values, and the query condition
    # is either a scalar value or a subcondition matcher.
    #
    # @example Match when any element equals the expected value
    #   matcher = ArrayRecordMatcher.build(42)
    #   matcher.match?([10, 42, 99])    #=> true
    #
    # @example Match using a nested matcher (e.g. condition is a hash)
    #   matcher = ArrayRecordMatcher.build({ '$gt' => 10 })
    #   matcher.match?([5, 20, 3])      #=> true
    #
    # This matcher is automatically invoked by LiteralMatcher when the record value is an array.
    #
    # @note This is distinct from `$in` or `$nin`, where the **condition** is an array.
    #       Here, the **record** is the array being matched against.
    #
    # @see Mongory::Matchers::InMatcher
    # @see Mongory::Matchers::LiteralMatcher
    class ArrayRecordMatcher < AbstractMultiMatcher
      # Initializes the collection matcher with a condition.
      #
      # @param condition [Object] the condition to match
      def initialize(condition, *)
        @condition_is_hash = condition.is_a?(Hash)
        super
      end

      # Matches the input collection.
      # Falls back to include? check unless condition is a Hash.
      #
      # @param collection [Object]
      # @return [Boolean]
      def match(collection)
        return true if @condition == collection
        return super if @condition_is_hash

        collection.include?(@condition)
      end

      # Lazily builds a shared ElemMatchMatcher used for complex field matching.
      #
      # @see ElemMatchMatcher
      # @return [ElemMatchMatcher] shared matcher instance for field conditions
      # @!method elem_matcher
      define_matcher(:elem) do
        ElemMatchMatcher.build({})
      end

      # Builds sub-matchers depending on the key:
      #   - Integer or numeric string: treated as array index (FieldMatcher)
      #   - Operator: resolved via Matchers.lookup
      #   - Else: merged into ElemMatchMatcher condition
      #
      # @see ElemMatchMatcher
      # @see FieldMatcher
      # @see Matchers.lookup
      # @param key [Object] the key from the condition hash
      # @param value [Object] the associated condition value
      # @return [AbstractMatcher] matcher instance for this field/operator
      def build_sub_matcher(key, value)
        case key
        when Integer
          FieldMatcher.build(key, value)
        when /^-?\d+$/
          FieldMatcher.build(key.to_i, value)
        when *Matchers::OPERATOR_TO_CLASS_MAPPING.keys
          Matchers.lookup(key).build(value)
        else
          elem_matcher.condition[key] = value
          elem_matcher
        end
      end

      # Combines results using `:all?` for multi-match logic.
      #
      # @return [Symbol]
      def operator
        :all?
      end

      # Performs recursive validity checks on nested matchers if condition is a Hash.
      #
      # @return [void]
      def deep_check_validity!
        super if @condition_is_hash
      end

      # Outputs the tree representation of this matcher.
      # Can optionally yield to allow conditional delegation to submatchers.
      #
      # @param prefix [String]
      # @param is_last [Boolean]
      # @return [void]
      def render_tree(prefix = '', is_last: true)
        super do
          return unless @condition_is_hash
        end
      end
    end
  end
end
