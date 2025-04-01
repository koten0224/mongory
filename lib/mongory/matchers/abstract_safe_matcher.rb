# frozen_string_literal: true

require 'mongory/matchers/abstract_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Abstract class
    class AbstractSafeMatcher < AbstractMatcher
      BOOLEAN_VALUES = [true, false].freeze

      def match?(record)
        preprocess(record).send(operator, @condition)
      rescue StandardError
        false
      end

      def preprocess(record)
        record
      end

      def operator; end
    end
  end
end
