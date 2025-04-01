# frozen_string_literal: true

require 'mongory/matchers/main_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class NotMatcher < MainMatcher
      def match?(data)
        !super(data)
      end
    end
  end
end
