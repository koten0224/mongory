# frozen_string_literal: true

require 'mongory/matchers/eq_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class GtMatcher < EqMatcher
      def match?(data)
        return false if data == KEY_NOT_FOUND

        super
      end

      def preprocess(data)
        data
      end

      def operator
        :>
      end
    end
  end
end
