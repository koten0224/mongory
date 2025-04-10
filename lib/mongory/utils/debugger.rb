# frozen_string_literal: true

module Mongory
  module Utils
    # Debugger toggles matcher evaluation tracing on or off.
    #
    # When enabled, all matchers use `debug_match` instead of `regular_match`,
    # allowing developers to instrument and trace matching logic at runtime.
    #
    # This is primarily used for development and debugging.
    Debugger = SingletonBuilder.new('Mongory::Debugger') do
      class << self
        # indentation level for formatted output
        attr_accessor :indent_level
      end

      @indent_level = 0

      # Enables debug mode by aliasing `match?` to `debug_match`.
      def enable
        Matchers::AbstractMatcher.alias_method :match?, :debug_match
      end

      # Disables debug mode by restoring `match?` to `regular_match`.
      def disable
        Matchers::AbstractMatcher.alias_method :match?, :regular_match
      end
    end
  end
end
