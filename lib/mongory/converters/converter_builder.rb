# frozen_string_literal: true

module Mongory
  module Converters
    # ConverterBuilder provides a flexible DSL-style mechanism
    # for dynamically converting objects based on their class.
    #
    # It allows you to register conversion rules for specific classes,
    # with optional fallback behavior.
    #
    # @example Basic usage
    #   builder = ConverterBuilder.new do
    #     register(String) { |v| v.upcase }
    #   end
    #   builder.convert("hello") #=> "HELLO"
    class ConverterBuilder
      include Utils

      # @private
      Registry = Struct.new(:klass, :exec)

      # @private
      NOTHING = SingletonMarker.new('NOTHING')

      # @param block [Proc] optional DSL configuration block
      def initialize(&block)
        @registries = []
        @fallback = Proc.new { |*| self }
        instance_eval(&block) if block_given?
      end

      # Applies the registered conversion to the given target object.
      #
      # @param target [Object] the object to convert
      # @param other [Object] optional secondary argument
      # @return [Object] the result of the conversion
      def convert(target, other = NOTHING)
        @registries.each do |registry|
          next unless target.is_a?(registry.klass)

          return exec_convert(target, other, &registry.exec)
        end

        exec_convert(target, other, &@fallback)
      end

      # Executes the conversion block with the appropriate arguments.
      #
      # @param target [Object]
      # @param other [Object]
      # @yield the conversion block
      # @return [Object]
      def exec_convert(target, other, &block)
        if other == NOTHING
          target.instance_exec(&block)
        else
          target.instance_exec(other, &block)
        end
      end

      # Yields self to a block for configuration, then freezes the builder.
      #
      # @yield [ConverterBuilder]
      # @return [ConverterBuilder] the frozen builder
      def configure
        yield self
        freeze
      end

      # Freezes internal registry state as well.
      #
      # @return [ConverterBuilder]
      def freeze
        super
        @registries.freeze
      end

      # Registers a conversion rule for a given class.
      #
      # @param klass [Class, Module] the target class
      # @param converter [Symbol, nil] method name to call as a conversion
      # @yield [*args] block that performs the conversion
      # @return [void]
      # @raise [RuntimeError] if input is invalid
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

    private_constant :ConverterBuilder
  end
end
