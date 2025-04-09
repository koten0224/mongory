# frozen_string_literal: true

module Mongory
  # Temp Description
  module Converters
    KeyConverter = ConverterBuilder.new do |c|
      @fallback = ->(x) { { self => x } }

      register(String) do |other|
        ret = {}
        *keys, last_key = split('.')
        last_hash = keys.reduce(ret) do |res, key|
          next_res = res[key] = {}
          next_res
        end

        last_hash[last_key] = other
        ret
      end

      register(Symbol) do |other|
        c.convert(to_s, other)
      end

      register(QueryOperator, :__expr_part__)
    end

    private_constant set_constant_display :KeyConverter
  end
end
