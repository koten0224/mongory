# frozen_string_literal: true

module Mongory
  module Matchers
    # CollectionMatcher is responsible for matching an array (or array-like object)
    # against a given condition. It supports both exact element matching and
    # more complex nested logic using an `ElemMatchMatcher`.
    #
    # If the condition is not a Hash, it falls back to simple inclusion check (`Array#include?`).
    #
    # If the condition is a Hash, each key/value is used to build an appropriate matcher.
    #
    # Submatchers are built dynamically depending on whether the key is an integer index,
    # numeric string, operator, or a regular hash field.
    #
    # @example
    #   matcher = CollectionMatcher.build({ 0 => { :$gt => 5 }, status: "active" })
    #   matcher.match?([10, { status: "active" }]) #=> true if all conditions are satisfied
    #
    # @see AbstractMultiMatcher
    class CollectionMatcher < AbstractMultiMatcher
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
      #   - Integer or numeric string: treated as array index (DigValueMatcher)
      #   - Operator: resolved via Matchers.lookup
      #   - Else: merged into ElemMatchMatcher condition
      #
      # @see ElemMatchMatcher
      # @see DigValueMatcher
      # @see Matchers.lookup
      # @param key [Object] the key from the condition hash
      # @param value [Object] the associated condition value
      # @return [AbstractMatcher] matcher instance for this field/operator
      def build_sub_matcher(key, value)
        case key
        when Integer
          DigValueMatcher.build(key, value)
        when /^-?\d+$/
          DigValueMatcher.build(key.to_i, value)
        when *Matchers::OPERATOR_TO_CLASS_MAPPING.keys
          Matchers.lookup(key).build(value)
        else
          elem_matcher.condition.merge!(key => value)
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
      # @param pp [PP]
      # @param prefix [String]
      # @param is_last [Boolean]
      # @return [void]
      def render_tree(*)
        super do
          return unless @condition_is_hash
        end
      end
    end
  end
end
