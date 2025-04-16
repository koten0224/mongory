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
    ConditionConverter = Utils::SingletonBuilder.new('Mongory::Converters::ConditionConverter') do
      # Converts a flat condition hash into a nested structure.
      #
      # @param condition [Hash]
      # @return [Hash] the transformed nested condition
      def convert(condition)
        result = {}
        condition.each_pair do |k, v|
          converted_value = value_converter.convert(v)
          converted_pair = key_converter.convert(k, converted_value)
          result.merge!(converted_pair, &deep_merge_block)
        end
        result
      end

      # Opens a configuration block to register more converters.
      #
      # @yield DSL block to configure more rules
      # @return [void]
      def configure
        yield self
        freeze
      end

      # Provides a block that merges values for overlapping keys in a deep way.
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

      # Returns the key converter used to transform condition keys.
      #
      # @return [AbstractConverter]
      def key_converter
        KeyConverter
      end

      # Returns the value converter used to transform condition values.
      #
      # @return [AbstractConverter]
      def value_converter
        ValueConverter
      end

      # Freezes internal converters to prevent further modification.
      #
      # @return [void]
      def freeze
        deep_merge_block
        super
        key_converter.freeze
        value_converter.freeze
      end
    end
  end
end
