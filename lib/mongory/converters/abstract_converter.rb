# frozen_string_literal: true

module Mongory
  module Converters
    # Temp Description
    class AbstractConverter
      Registry = Struct.new(:klass, :exec)
      NOTHING = Object.new

      def initialize
        @registries = []
        @fallback = Proc.new { NOTHING }
      end

      def convert(data)
        @registries.each do |registry|
          next unless data.is_a?(registry.klass)

          return data.instance_exec(&registry.exec)
        end

        data.instance_exec(&@fallback)
      end

      def configure
        yield self
      end

      def fallback(&block)
        @fallback = block
      end

      def register(klass, converter = nil, &block)
        raise 'converter or block is required.' if [converter, block].compact.empty?
        raise 'A class or module is reuqired.' unless klass.is_a?(Module)

        if converter.is_a?(Symbol)
          register(klass) { send(converter) }
        elsif block.is_a?(Proc)
          @registries.unshift(Registry.new(klass, block))
        else
          raise 'Support Symbol and block only.'
        end
      end
    end

    private_constant :AbstractConverter
  end
end
