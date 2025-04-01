# frozen_string_literal: true

require 'mongory/matchers/multi_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class OrMatcher < MultiMatcher
      def build_sub_matcher(condition)
        MainMatcher.new(condition)
      end

      def operator
        :any?
      end

      def check_validity!(condition)
        raise TypeError, '$or needs an array' unless condition.is_a?(Array)
      end

      alias_method :preprocess, :normalize_key
    end
  end
end
