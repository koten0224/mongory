# frozen_string_literal: true

# Temp Description
module Mongory
  DataConverter = Object.new
  DataConverter.singleton_class.class_eval do
    def convert(data)
      registry.each do |klass, converter|
        next unless data.is_a?(klass)

        return converter.call(data)
      end

      data
    end

    def configure
      yield self
    end

    def register(klass, converter = nil, &block)
      raise 'converter or block is required.' if [converter, block].compact.empty?
      raise 'A class or module is reuqired.' unless klass.is_a?(Module)

      if converter.is_a?(Symbol)
        register(klass, &converter)
      elsif block.is_a?(Proc)
        registry.unshift([klass, block])
      else
        raise 'Support Symbol and block only.'
      end
    end

    private

    def registry
      @registry ||= []
    end
  end

  DataConverter.configure do |c|
    c.register(Hash) do |x|
      x.transform_keys(&:to_s)
    end

    [Symbol, Date].each do |klass|
      c.register(klass, :to_s)
    end
    [Time, DateTime].each do |klass|
      c.register(klass, :iso8601)
    end
  end
end
