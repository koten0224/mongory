# frozen_string_literal: true

require 'mongory/matchers/base_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class NinMatcher < BaseMatcher
      def match?(record)
        blank?(@condition & Array(normalize_key(record)))
      end

      def check_validity!(condition)
        raise TypeError, '$nin needs an array' unless condition.is_a?(Array)
      end
    end
  end
end
