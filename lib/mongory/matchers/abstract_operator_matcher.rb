# frozen_string_literal: true

module Mongory
  # Temp Description
  module Matchers
    # Abstract class
    class AbstractOperatorMatcher < AbstractMatcher
      BOOLEAN_VALUES = [true, false].freeze

      def match(record)
        preprocess(record).send(operator, @condition)
      rescue StandardError
        false
      end

      def preprocess(record)
        normalize(record)
      end

      def operator; end
    end
  end
end
