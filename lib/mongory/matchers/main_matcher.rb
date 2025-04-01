# frozen_string_literal: true

require 'mongory/matchers/base_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class MainMatcher < BaseMatcher
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

      def hash_matcher
        return @hash_matcher if defined?(@hash_matcher)

        @hash_matcher = HashMatcher.new(@condition)
      end
    end
  end
end
