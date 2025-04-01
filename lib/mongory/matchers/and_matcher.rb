# frozen_string_literal: true

require 'mongory/matchers/multi_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class AndMatcher < MultiMatcher
      def build_sub_matcher(condition)
        MainMatcher.new(condition)
      end

      def operator
        :all?
      end

      def check_validity!(condition)
        raise TypeError, '$and needs an array' unless condition.is_a?(Array)
      end

      alias_method :preprocess, :normalize_key
    end
  end
end
