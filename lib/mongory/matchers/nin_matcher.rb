# frozen_string_literal: true

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class NinMatcher < AbstractMatcher
      def match(record)
        blank?(@condition & Array(record))
      end

      def check_validity!
        raise TypeError, '$nin needs an array' unless @condition.is_a?(Array)
      end
    end
  end
end
