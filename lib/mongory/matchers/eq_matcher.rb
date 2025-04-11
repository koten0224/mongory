# frozen_string_literal: true

module Mongory
  module Matchers
    # EqMatcher matches values using the equality operator `==`.
    # 
    # It inherits from AbstractOperatorMatcher and defines its operator as `:==`.
    #
    # Used for conditions like:
    #   { age: { :$eq => 30 } }
    #
    # This matcher supports any Ruby object that implements `#==`.
    #
    # @example
    #   matcher = EqMatcher.build(42)
    #   matcher.match?(42)        #=> true
    #   matcher.match?("42")      #=> false
    #
    # @see AbstractOperatorMatcher
    class EqMatcher < AbstractOperatorMatcher
      # Returns the Ruby equality operator to be used in matching.
      #
      # @return [Symbol] the equality operator symbol
      def operator
        :==
      end
    end
  end
end
