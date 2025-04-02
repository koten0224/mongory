# frozen_string_literal: true

require 'mongory/matchers/abstract_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class InMatcher < AbstractMatcher
      def match?(record)
        present?(@condition & Array(record))
      end

      def check_validity!
        raise TypeError, '$in needs an array' unless @condition.is_a?(Array)
      end
    end
  end
end
