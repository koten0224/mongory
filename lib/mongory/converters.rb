# frozen_string_literal: true

module Mongory
  # Temp Description
  module Converters
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
