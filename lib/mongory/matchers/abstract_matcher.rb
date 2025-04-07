# frozen_string_literal: true

module Mongory
  # Temp Description
  module Matchers
    # Abstract class
    class AbstractMatcher
      include Utils

      KEY_NOT_FOUND = SingletonMarker.new('KEY_NOT_FOUND')

      def self.define_matcher(name, &block)
        define_instance_cache_method(:"#{name}_matcher", &block)
      end

      attr_reader :condition

      def initialize(condition, ignore_convert: false)
        @condition = condition
        @ignore_convert = ignore_convert

        check_validity!
      end

      def match(*); end

      def match?(record)
        match(record)
      end

      alias_method :regular_match, :match?

      def debug_match(record)
        Debugger.indent_level += 1
        result = match(record)
        puts (' ' * Debugger.indent_level * 2) + display(record, result)
        result
      rescue Exception
        Debugger.indent_level = 1
        raise
      ensure
        Debugger.indent_level -= 1
      end

      private

      def check_validity!; end

      def normalize(record)
        record == KEY_NOT_FOUND ? nil : record
      end

      def display(record, result)
        result = result ? "\e[30;42mMatched\e[0m" : "\e[30;41mDismatch\e[0m"

        "#{self.class} => " \
          "result: #{result}, " \
          "condition: #{@condition.inspect}, " \
          "record: #{record.inspect}"
      end
    end
  end
end
