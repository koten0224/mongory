# frozen_string_literal: true

require_relative 'abstract_operator_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class EqMatcher < AbstractOperatorMatcher
      def operator
        :==
      end
    end
  end
end
