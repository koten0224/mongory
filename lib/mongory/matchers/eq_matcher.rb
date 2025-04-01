# frozen_string_literal: true

require 'mongory/matchers/base_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class EqMatcher < BaseMatcher
      BOOLEAN_VALUES = [true, false].freeze

      def match?(data)
        preprocess(data).send(operator, @condition)
      rescue StandardError
        false
      end

      def operator
        :==
      end

      alias_method :preprocess, :normalize_key
    end
  end
end
