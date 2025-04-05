# frozen_string_literal: true

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class DefaultMatcher < AbstractMatcher
      def match?(record)
        record = Mongory.data_converter.convert(record)
        if @condition == record
          true
        elsif record.is_a?(Array)
          collection_matcher.match?(record)
        elsif @condition.is_a?(Hash)
          condition_matcher.match?(record)
        else
          false
        end
      end

      define_matcher(:collection) do
        CollectionMatcher.new(@condition)
      end

      define_matcher(:condition) do
        ConditionMatcher.new(@condition)
      end
    end
  end
end
