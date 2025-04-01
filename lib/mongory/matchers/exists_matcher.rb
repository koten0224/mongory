# frozen_string_literal: true

require 'mongory/matchers/abstract_safe_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class ExistsMatcher < AbstractSafeMatcher
      def preprocess(record)
        record != KEY_NOT_FOUND
      end

      def operator
        :==
      end

      def check_validity!(condition)
        raise TypeError, '$exists needs a boolean' unless BOOLEAN_VALUES.include?(condition)
      end
    end
  end
end
