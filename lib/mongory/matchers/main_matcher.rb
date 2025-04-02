# frozen_string_literal: true

require 'mongory/matchers/abstract_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class MainMatcher < AbstractMatcher
      def match?(record)
        if @condition == record
          true
        elsif @condition.is_a?(Hash)
          hash_matcher.match?(record)
        elsif record.is_a?(Array) # and @condition not a hash
          record.include?(@condition)
        else
          false
        end
      end

      define_matcher(:hash) do
        HashMatcher.new(@condition)
      end
    end
  end
end
