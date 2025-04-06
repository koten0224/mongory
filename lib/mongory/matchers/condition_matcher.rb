# frozen_string_literal: true

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class ConditionMatcher < AbstractMultiMatcher
      def build_sub_matcher(key, value)
        case key
        when *Matchers::OPERATOR_TO_CLASS_MAPPING.keys
          Matchers.lookup(key).new(value)
        else
          DigValueMatcher.new(key, value)
        end
      end

      def operator
        :all?
      end
    end
  end
end
