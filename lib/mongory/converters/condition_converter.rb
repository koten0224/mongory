# frozen_string_literal: true

module Mongory
  module Converters
    # Converts flat query conditions into nested hash structure.
    #
    # Used by QueryBuilder to normalize condition input for internal matching.
    #
    # Combines key transformation (via KeyConverter) and
    # value normalization (via ValueConverter), and merges overlapping keys.
    #
    # @example
    #   ConditionConverter.convert({ "foo.bar" => 1, "foo.baz" => 2 })
    #   # => { "foo" => { "bar" => 1, "baz" => 2 } }
    ConditionConverter = Utils::SingletonBuilder.new('ConditionConverter') do
      # Converts a flat condition hash into a nested structure.
      #
      # @param condition [Hash]
      # @return [Hash] nested condition
      def convert(condition)
        result = {}
        condition.each_pair do |k, v|
          converted_value = value_converter.convert(v)
          converted_pair = key_converter.convert(k, converted_value)
          result.merge!(converted_pair, &deep_merge_block)
        end
        result
      end

      # Deep merge block used to merge nested hashes
      #
      # @return [Proc]
      def deep_merge_block
        @deep_merge_block ||= Proc.new do |_, a, b|
          if a.is_a?(Hash) && b.is_a?(Hash)
            a.merge(b, &deep_merge_block)
          else
            b
          end
        end
      end

      # Returns the key converter
      #
      # @return [ConverterBuilder]
      def key_converter
        KeyConverter
      end

      # Returns the value converter
      #
      # @return [ConverterBuilder]
      def value_converter
        ValueConverter
      end

      # Prepares and freezes all internal components
      #
      # @return [ConditionConverter]
      def freeze
        deep_merge_block
        super
        key_converter.freeze
        value_converter.freeze
      end
    end
  end
end
