# frozen_string_literal: true

module Mongory
  module Converters
    # Converts dotted keys like `"foo.bar"` or `:"foo.bar"` into nested hashes.
    #
    # Used by ConditionConverter to build query structures from flat input.
    #
    # - `"a.b.c" => v` becomes `{ "a" => { "b" => { "c" => v } } }`
    # - Symbols are stringified and delegated to String logic
    # - QueryOperator dispatches to internal DSL hook
    KeyConverter = ConverterBuilder.new('KeyConverter') do |c|
      # fallback if key type is unknown — returns { self => value }
      @fallback = ->(x) { { self => x } }

      # - `"a.b.c" => v` becomes `{ "a" => { "b" => { "c" => v } } }`
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

      # - `:"a.b.c" => v` becomes `{ "a" => { "b" => { "c" => v } } }`
      register(Symbol) do |other|
        c.convert(to_s, other)
      end

      # - `:"a.b.c".present => true` becomes `{ "a" => { "b" => { "c" => { "$present" => true } } } }`
      register(QueryOperator, :__expr_part__)
    end
  end
end
