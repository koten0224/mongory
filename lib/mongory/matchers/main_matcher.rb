# frozen_string_literal: true

require_relative 'abstract_matcher'

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class MainMatcher < AbstractMatcher
      def match?(record)
        if @condition == record
          true
        elsif record.is_a?(Array)
          collection_matcher.match?(record)
        elsif @condition.is_a?(Hash)
          hash_matcher.match?(record)
        else
          false
        end
      end

      define_matcher(:hash) do
        HashMatcher.new(@condition)
      end

      define_matcher(:collection) do
        CollectionMatcher.new(@condition)
      end
    end
  end
end
