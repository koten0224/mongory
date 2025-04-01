# frozen_string_literal: true

require 'mongory/matchers/base_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Abstract class
    class MultiMatcher < BaseMatcher
      def match?(data)
        data = preprocess(data)
        matchers.send(operator) do |matcher|
          matcher.match?(data)
        end
      end

      def matchers
        return @matchers if defined?(@matchers)

        @matchers = @condition.map do |(*sub_condition)|
          build_sub_matcher(*sub_condition)
        end
      end

      def preprocess(data)
        data
      end

      def build_sub_matcher(*); end
      def operator; end
    end
  end
end
