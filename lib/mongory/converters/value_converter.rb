# frozen_string_literal: true

module Mongory
  module Converters
    # Converts query values into normalized matcher-friendly format.
    #
    # Used by ConditionConverter to prepare values in nested queries.
    #
    # - Arrays are recursively converted
    # - Hashes are interpreted as nested conditions
    # - Regex becomes a Mongo-style `$regex` hash
    # - Strings and Integers are passed through
    # - Everything else falls back to DataConverter
    ValueConverter = ConverterBuilder.new('Mongory::Converters::ValueConverter') do |c|
      # fallback for unrecognized types
      @fallback = -> { DataConverter.convert(self) }

      register(Array) do
        map { |x| c.convert(x) }
      end

      register(Hash) do
        ConditionConverter.convert(self)
      end

      [String, Integer].each do |klass|
        register(klass) { self }
      end
    end
  end
end
