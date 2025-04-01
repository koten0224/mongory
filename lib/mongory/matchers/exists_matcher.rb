# frozen_string_literal: true

require 'mongory/matchers/eq_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class ExistsMatcher < EqMatcher
      def preprocess(record)
        record != KEY_NOT_FOUND
      end

      def check_validity!(condition)
        raise TypeError, '$exists needs a boolean' unless BOOLEAN_VALUES.include?(condition)
      end
    end
  end
end
