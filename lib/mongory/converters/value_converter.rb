# frozen_string_literal: true

module Mongory
  # Temp Description
  module Converters
    ValueConverter = AbstractConverter.new
    ValueConverter.instance_eval do |c|
      @fallback = -> { DataConverter.convert(self) }

      register(Array) do
        map { |x| c.convert(x) }
      end

      register(Hash) do
        ConditionConverter.convert(self)
      end

      register(Regexp) do
        { '$regex' => source }
      end

      [String, Integer].each do |klass|
        register(klass) { self }
      end
    end

    private_constant :ValueConverter
  end
end
