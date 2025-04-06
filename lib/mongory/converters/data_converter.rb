# frozen_string_literal: true

module Mongory
  # Temp Description
  module Converters
    DataConverter = AbstractConverter.new
    DataConverter.instance_eval do
      fallback do
        self
      end

      register(Hash) do
        transform_keys(&:to_s)
      end

      [Symbol, Date].each do |klass|
        register(klass, :to_s)
      end
      [Time, DateTime].each do |klass|
        register(klass, :iso8601)
      end
    end
  end
end
