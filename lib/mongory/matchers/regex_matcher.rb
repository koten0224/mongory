# frozen_string_literal: true

require 'mongory/matchers/base_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class RegexMatcher < BaseMatcher
      def match?(data)
        return false unless data.is_a?(String)

        data.match?(@condition)
      rescue StandardError
        false
      end

      def check_validity!(condition)
        raise TypeError, '$regex needs a string' unless condition.is_a?(String)
      end
    end
  end
end
