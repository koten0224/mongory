# frozen_string_literal: true

require 'mongory/matchers/abstract_operator_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class PresentMatcher < AbstractOperatorMatcher
      def preprocess(record)
        present?(normalize(record))
      end

      def operator
        :==
      end

      def check_validity!(condition)
        raise TypeError, '$present needs a boolean' unless BOOLEAN_VALUES.include?(condition)
      end
    end
  end
end
