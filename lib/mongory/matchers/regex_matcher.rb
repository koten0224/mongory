# frozen_string_literal: true

require 'mongory/matchers/abstract_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class RegexMatcher < AbstractMatcher
      def match?(record)
        return false unless record.is_a?(String)

        record.match?(@condition)
      rescue StandardError
        false
      end

      def check_validity!(condition)
        raise TypeError, '$regex needs a string' unless condition.is_a?(String)
      end
    end
  end
end
