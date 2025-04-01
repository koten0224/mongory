# frozen_string_literal: true

require 'mongory/matchers/base_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class InMatcher < BaseMatcher
      def match?(data)
        Mongory::Utils.present?(@condition & Array(normalize_key(data)))
      end

      def check_validity!(condition)
        raise TypeError, '$in needs an array' unless condition.is_a?(Array)
      end
    end
  end
end
