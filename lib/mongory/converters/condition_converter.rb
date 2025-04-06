# frozen_string_literal: true

module Mongory
  # Temp Description
  module Converters
    ConditionConverter = AbstractConverter.new
    ConditionConverter.instance_eval do
      def key_converter
        KeyConverter
      end

      def value_converter
        ValueConverter
      end

      configure do |c|
        c.register(Hash) do
          c.value_converter.convert_hash(self)
        end
      end
    end
  end
end
