# frozen_string_literal: true

module Mongory
  # Temp Description
  module Converters
    ValueConverter = AbstractConverter.new
    ValueConverter.instance_eval do
      def convert_hash(hash)
        deep_merge_block = Proc.new do |_, this_val, other_val|
          if this_val.is_a?(Hash) && other_val.is_a?(Hash)
            this_val.merge(other_val, &deep_merge_block)
          else
            other_val
          end
        end

        hash.each_with_object({}) do |(k, v), result|
          result.merge!(KeyConverter.convert(k, convert(v)), &deep_merge_block)
        end
      end

      configure do |c|
        c.fallback do
          Mongory.data_converter.convert(self)
        end

        c.register(Array) do
          map { |x| c.convert(x) }
        end

        c.register(Hash) do
          c.convert_hash(self)
        end

        c.register(Regexp) do
          { '$regex' => source }
        end
      end
    end

    private_constant :ValueConverter
  end
end
