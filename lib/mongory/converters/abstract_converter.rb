# frozen_string_literal: true

module Mongory
  module Converters
    # AbstractConverter provides a flexible DSL-style mechanism
    # for dynamically converting objects based on their class.
    #
    # It allows you to register conversion rules for specific classes,
    # with optional fallback behavior.
    #
    # @example Basic usage
    #   converter = AbstractConverter.new do
    #     register(String) { |v| v.upcase }
    #   end
    #   converter.convert("hello") #=> "HELLO"
    class AbstractConverter < Utils::SingletonBuilder
      # @private
      Registry = Struct.new(:klass, :exec)

      # @private
      NOTHING = Utils::SingletonBuilder.new('NOTHING')

      # Initializes the builder with a label and optional configuration block.
      #
      # @param label [String] a name for the converter
      # @yield [block] optional configuration block
      def initialize(label, &block)
        @registries = []
        @fallback = Proc.new { |*| self }
        super
      end

      # Applies the registered conversion to the given target object.
      #
      # @param target [Object] the object to convert
      # @param other [Object] optional secondary value
      # @return [Object] converted result
      def convert(target, other = NOTHING)
        @registries.each do |registry|
          next unless target.is_a?(registry.klass)

          return exec_convert(target, other, &registry.exec)
        end

        exec_convert(target, other, &@fallback)
      end

      # Internal dispatch logic to apply a matching converter.
      #
      # @param target [Object] the object to match
      # @param other [Object] optional extra data
      # @yield fallback block if no converter is found
      # @return [Object]
      def exec_convert(target, other, &block)
        if other == NOTHING
          target.instance_exec(&block)
        else
          target.instance_exec(other, &block)
        end
      end

      # Opens a configuration block to register more converters.
      #
      # @yield DSL block to configure more rules
      # @return [void]
      def configure
        yield self
        freeze
      end

      # Freezes all internal registries.
      #
      # @return [void]
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
  end
end
