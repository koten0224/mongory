# frozen_string_literal: true

require 'mongory/matchers/abstract_multi_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class CollectionMatcher < AbstractMultiMatcher
      def match?(collection)
        return super if @condition.is_a?(Hash)

        collection.include?(@condition)
      end

      define_matcher(:elem) do
        ElemMatchMatcher.new({})
      end

      def build_sub_matcher(key, value)
        case key
        when Integer
          KeyValueMatcher.new(key, value)
        when /^\d+$/
          KeyValueMatcher.new(key.to_i, value)
        when *Matchers::OPERATOR_TO_CLASS_MAPPING.keys
          Matchers.lookup(key).new(value)
        else
          elem_matcher.condition.merge!(key => value)
          elem_matcher
        end
      end

      def operator
        :all?
      end
    end
  end
end
