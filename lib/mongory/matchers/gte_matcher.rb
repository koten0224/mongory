# frozen_string_literal: true

require 'mongory/matchers/abstract_operator_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class GteMatcher < AbstractOperatorMatcher
      def operator
        :>=
      end
    end
  end
end
