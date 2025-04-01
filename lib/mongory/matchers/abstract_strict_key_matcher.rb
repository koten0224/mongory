# frozen_string_literal: true

require 'mongory/matchers/abstract_safe_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Abstract class
    class AbstractStrictKeyMatcher < AbstractSafeMatcher
      def match?(record)
        return false if record == KEY_NOT_FOUND

        super
      end
    end
  end
end
