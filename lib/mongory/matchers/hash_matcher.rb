# frozen_string_literal: true

require 'mongory/matchers/abstract_multi_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class HashMatcher < AbstractMultiMatcher
      def match?(record)
        res = super
        if res.include?(KEY_NOT_FOUND)
          elem_matcher.match?(record)
        else
          res.all?
        end
      end

      def build_sub_matcher(key, value)
        KeyValueMatcher.new(key, value)
      end

      define_matcher(:elem) do
        ElemMatchMatcher.new(@condition)
      end

      def operator
        :map
      end
    end
  end
end
