# frozen_string_literal: true

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class NotMatcher < MainMatcher
      def match?(record)
        !super(record)
      end
    end
  end
end
