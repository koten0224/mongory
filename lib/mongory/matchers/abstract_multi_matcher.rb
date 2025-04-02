# frozen_string_literal: true

require 'mongory/matchers/abstract_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Abstract class
    class AbstractMultiMatcher < AbstractMatcher
      def match?(record)
        record = preprocess(record)
        matchers.send(operator) do |matcher|
          matcher.match?(record)
        end
      end

      define_instance_cache_method(:matchers) do
        @condition.map(&method(:build_sub_matcher))
      end

      def preprocess(record)
        record
      end

      def build_sub_matcher(*); end
      def operator; end
    end
  end
end
