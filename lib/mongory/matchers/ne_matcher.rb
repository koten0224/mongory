# frozen_string_literal: true

require 'mongory/matchers/eq_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class NeMatcher < EqMatcher
      def operator
        :!=
      end
    end
  end
end
