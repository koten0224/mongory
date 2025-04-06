# frozen_string_literal: true

module Mongory
  module Converters
    # Temp Description
    class AbstractConverter
      Registry = Struct.new(:klass, :exec)
      NOTHING = Object.new

      def initialize
        @registries = []
        @fallback = Proc.new { |*| self }
      end

      def convert(target, other = NOTHING)
        @registries.each do |registry|
          next unless target.is_a?(registry.klass)

          return exec_convert(target, other, &registry.exec)
        end

        exec_convert(target, other, &@fallback)
      end

      def exec_convert(target, other, &block)
        if other == NOTHING
          target.instance_exec(&block)
        else
          target.instance_exec(other, &block)
        end
      end

      def configure
        yield self
        freeze
      end

      def freeze
        super
        @registries.freeze
      end

      def register(klass, converter = nil, &block)
        raise 'converter or block is required.' if [converter, block].compact.empty?
        raise 'A class or module is reuqired.' unless klass.is_a?(Module)

        if converter.is_a?(Symbol)
          register(klass) { |*args, &bl| send(converter, *args, &bl) }
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
