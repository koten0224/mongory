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

      def hash_matcher
        return @hash_matcher if defined?(@hash_matcher)

        @hash_matcher = HashMatcher.new(@condition)
      end

      def clear
        remove_instance_variable(:@hash_matcher)
      end
    end
  end
end
