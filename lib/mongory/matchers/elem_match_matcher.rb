# frozen_string_literal: true

require 'mongory/matchers/main_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class ElemMatchMatcher < MainMatcher
      def match?(data)
        return false unless data.is_a?(Array)

        data.any? do |value|
          super(value)
        end
      end
    end
  end
end
