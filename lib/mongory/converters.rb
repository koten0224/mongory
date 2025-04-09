# frozen_string_literal: true

module Mongory
  # The Converters module provides a collection of tools to
  # transform query keys and values into a normalized internal form.
  #
  # These converters are used during query compilation to ensure that
  # all conditions are structured and typed consistently.
  #
  # Included converters:
  # - {ConverterBuilder} - base class for building converters
  # - {DataConverter} - normalizes raw values (e.g. dates, symbols)
  # - {KeyConverter} - expands dotted keys into nested hashes
  # - {ValueConverter} - transforms values into matcher-friendly structures
  # - {ConditionConverter} - orchestrates key+value conversion into final tree
  module Converters
    # Injects custom display string for constant (used in IRB/YARD).
    #
    # @param constant [Symbol] the constant name to patch
    # @return [Object] the constant itself
    def self.set_constant_display(constant)
      target = const_get(constant)
      display = "#<Mongory::Converters::#{constant}>"
      %i(inspect to_s).each do |mth|
        target.define_singleton_method(mth) { display }
      end

      constant
    end
  end
end

require_relative 'converters/converter_builder'
require_relative 'converters/condition_converter'
require_relative 'converters/data_converter'
require_relative 'converters/key_converter'
require_relative 'converters/value_converter'
