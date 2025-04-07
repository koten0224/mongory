# frozen_string_literal: true

module Mongory
  # Temp Description
  module Utils
    Debugger = Object.new
    Debugger.instance_eval do
      class << self
        attr_accessor :indent_level
      end

      @indent_level = 0

      def enable
        Matchers::AbstractMatcher.alias_method :match?, :debug_match
      end

      def disable
        Matchers::AbstractMatcher.alias_method :match?, :regular_match
      end
    end
  end
end
