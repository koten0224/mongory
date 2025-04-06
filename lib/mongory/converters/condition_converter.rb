# frozen_string_literal: true

module Mongory
  # Temp Description
  module Converters
    ConditionConverter = Object.new
    ConditionConverter.instance_eval do
      def convert(condition)
        result = {}
        condition.each_pair do |k, v|
          converted_value = value_converter.convert(v)
          converted_pair = key_converter.convert(k, converted_value)
          result.merge!(converted_pair, &deep_merge_block)
        end

        result
      end

      def deep_merge_block
        @deep_merge_block ||= Proc.new do |_, a, b|
          if a.is_a?(Hash) && b.is_a?(Hash)
            a.merge(b, &deep_merge_block)
          else
            b
          end
        end
      end

      def key_converter
        KeyConverter
      end

      def value_converter
        ValueConverter
      end

      def freeze
        deep_merge_block
        super
        key_converter.freeze
        value_converter.freeze
      end
    end
  end
end
