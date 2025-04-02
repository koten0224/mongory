# frozen_string_literal: true

require 'mongory/matchers/abstract_operator_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class ExistsMatcher < AbstractOperatorMatcher
      def preprocess(record)
        record != KEY_NOT_FOUND
      end

      def operator
        :==
      end

      def check_validity!
        raise TypeError, '$exists needs a boolean' unless BOOLEAN_VALUES.include?(@condition)
      end
    end
  end
end
