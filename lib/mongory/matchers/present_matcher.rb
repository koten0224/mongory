# frozen_string_literal: true

require 'mongory/matchers/eq_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class PresentMatcher < EqMatcher
      def preprocess(data)
        Mongory::Utils.present?(super(data))
      end

      def check_validity!(condition)
        raise TypeError, '$present needs a boolean' unless BOOLEAN_VALUES.include?(condition)
      end
    end
  end
end
