# frozen_string_literal: true

require 'mongory/matchers/gt_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class LtMatcher < GtMatcher
      def operator
        :<
      end
    end
  end
end
