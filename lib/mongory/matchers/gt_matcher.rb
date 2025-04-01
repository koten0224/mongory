# frozen_string_literal: true

require 'mongory/matchers/eq_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class GtMatcher < EqMatcher
      def match?(record)
        return false if record == KEY_NOT_FOUND

        super
      end

      def preprocess(record)
        record
      end

      def operator
        :>
      end
    end
  end
end
