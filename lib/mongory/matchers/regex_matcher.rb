# frozen_string_literal: true

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class RegexMatcher < AbstractOperatorMatcher
      def operator
        :match?
      end

      def preprocess(record)
        return '' unless record.is_a?(String)

        record
      end

      def check_validity!
        raise TypeError, '$regex needs a string' unless @condition.is_a?(String)
      end
    end
  end
end
