# frozen_string_literal: true

require_relative 'abstract_multi_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class OrMatcher < AbstractMultiMatcher
      def build_sub_matcher(condition)
        MainMatcher.new(condition)
      end

      def operator
        :any?
      end

      def check_validity!
        raise TypeError, '$or needs an array' unless @condition.is_a?(Array)
      end
    end
  end
end
