# frozen_string_literal: true

require 'mongory/matchers/multi_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class HashMatcher < MultiMatcher
      def build_sub_matcher(match_key, match_value)
        KeyValueMatcher.new(match_key, match_value)
      end

      def operator
        :all?
      end
    end
  end
end
