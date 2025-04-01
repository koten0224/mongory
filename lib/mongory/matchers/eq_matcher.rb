# frozen_string_literal: true

require 'mongory/matchers/abstract_safe_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class EqMatcher < AbstractSafeMatcher
      def operator
        :==
      end

      alias_method :preprocess, :normalize
    end
  end
end
