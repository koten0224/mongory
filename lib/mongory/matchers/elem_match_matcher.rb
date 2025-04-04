# frozen_string_literal: true

require_relative 'main_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class ElemMatchMatcher < MainMatcher
      def match?(record)
        return false unless record.is_a?(Array)

        record.any? do |value|
          super(value)
        end
      end
    end
  end
end
