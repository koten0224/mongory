# frozen_string_literal: true

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class ElemMatchMatcher < DefaultMatcher
      def match?(record)
        return false unless record.is_a?(Array)

        record.any? do |value|
          super(value)
        end
      end
    end
  end
end
