# frozen_string_literal: true

module Mongory
  module Converters
    # Provides a default converter that normalizes input data types
    # for internal query processing.
    #
    # - Hash keys are stringified
    # - Symbols and Dates are converted to string
    # - Time and DateTime objects are ISO8601-encoded
    # - Strings and Integers are passed through as-is
    #
    # This converter is typically applied to raw query values.
    DataConverter = ConverterBuilder.new('DataConverter') do
      register(Hash) do
        transform_keys(&:to_s)
      end

      [Symbol, Date].each do |klass|
        register(klass, :to_s)
      end

      [Time, DateTime].each do |klass|
        register(klass, :iso8601)
      end

      [String, Integer].each do |klass|
        register(klass) { self }
      end
    end
  end
end
