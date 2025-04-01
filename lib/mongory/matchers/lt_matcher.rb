# frozen_string_literal: true

require 'mongory/matchers/abstract_strict_key_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class LtMatcher < AbstractStrictKeyMatcher
      def operator
        :<
      end
    end
  end
end
