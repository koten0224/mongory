# frozen_string_literal: true

module Mongory
  module Utils
    # Temp Description
    class SingletonMarker
      def initialize(label)
        @label = label
      end

      def inspect
        "#<#{@label}>"
      end

      def to_s
        "#<#{@label}>"
      end
    end

    private_constant :SingletonMarker
  end
end
