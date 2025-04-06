# frozen_string_literal: true

module Mongory
  # Temp Description
  module Converters
    ConditionConverter = Object.new
    ConditionConverter.instance_eval do
      def convert(condition)
        condition.each_with_object({}) do |(k, v), result|
          converted_value = value_converter.convert(v)
          converted_pair = key_converter.convert(k, converted_value)
          result.merge!(converted_pair, &deep_merge_block)
        end
      end

      def deep_merge_block
        @deep_merge_block ||= Proc.new do |_, this_val, other_val|
          if this_val.is_a?(Hash) && other_val.is_a?(Hash)
            this_val.merge(other_val, &deep_merge_block)
          else
            other_val
          end
        end
      end

      def key_converter
        KeyConverter
      end

      def value_converter
        ValueConverter
      end
    end
  end
end
