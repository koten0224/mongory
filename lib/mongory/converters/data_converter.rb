# frozen_string_literal: true

module Mongory
  # Temp Description
  module Converters
    DataConverter = AbstractConverter.new
    DataConverter.configure do |c|
      c.fallback do
        self
      end

      c.register(Hash) do
        transform_keys(&:to_s)
      end

      [Symbol, Date].each do |klass|
        c.register(klass, :to_s)
      end
      [Time, DateTime].each do |klass|
        c.register(klass, :iso8601)
      end
    end
  end
end
