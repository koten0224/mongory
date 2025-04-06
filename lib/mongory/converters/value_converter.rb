# frozen_string_literal: true

module Mongory
  # Temp Description
  module Converters
    ValueConverter = AbstractConverter.new
    ValueConverter.configure do |c|
      c.fallback do
        DataConverter.convert(self)
      end

      c.register(Array) do
        map { |x| c.convert(x) }
      end

      c.register(Hash) do
        ConditionConverter.convert(self)
      end

      c.register(Regexp) do
        { '$regex' => source }
      end
    end

    private_constant :ValueConverter
  end
end
