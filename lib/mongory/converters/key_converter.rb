# frozen_string_literal: true

module Mongory
  # Temp Description
  module Converters
    KeyConverter = AbstractConverter.new
    KeyConverter.instance_eval do
      def convert(key, value)
        @registries.each do |registry|
          next unless key.is_a?(registry.klass)

          return key.instance_exec(value, &registry.exec)
        end

        { key => value }
      end

      configure do |c|
        c.register(String) do |other|
          ret = {}
          *keys, last_key = split('.')
          last_hash = keys.reduce(ret) do |res, key|
            next_res = res[key] = {}
            next_res
          end

          last_hash[last_key] = other
          ret
        end

        c.register(Symbol) do |other|
          c.convert(to_s, other)
        end

        c.register(QueryOperator) do |other|
          { @name => { @operator => other } }
        end
      end
    end

    private_constant :KeyConverter
  end
end
