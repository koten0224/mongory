# frozen_string_literal: true

module Mongory
  # Temp Description
  module Converters
    DataConverter = AbstractConverter.new
    DataConverter.instance_eval do
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
