# frozen_string_literal: true

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class AndMatcher < AbstractMultiMatcher
      def build_sub_matcher(condition)
        DefaultMatcher.new(condition, ignore_convert: true)
      end

      def operator
        :all?
      end

      def preprocess(record)
        Mongory.data_converter.convert(record)
      end

      def check_validity!
        raise TypeError, '$and needs an array' unless @condition.is_a?(Array)
      end
    end
  end
end
