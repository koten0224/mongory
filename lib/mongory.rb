# frozen_string_literal: true

require 'time'
require 'date'
require_relative 'mongory/version'
require_relative 'mongory/utils'
require_relative 'mongory/matchers'
require_relative 'mongory/query_matcher'
require_relative 'mongory/query_builder'
require_relative 'mongory/query_operator'
require_relative 'mongory/converters'

# Main namespace for Mongory DSL and configuration.
#
# This module exposes the top-level API for building queries
# and accessing core components like converters and debugger.
module Mongory
  # Creates a new query builder for the given records.
  #
  # @param records [Enumerable] any collection of data
  # @return [QueryBuilder]
  def self.build_query(records)
    QueryBuilder.new(records)
  end

  # Yields Mongory for configuration and freezes key components.
  #
  # @example Configure converters
  #   Mongory.configure do |mc|
  #     mc.data_converter.configure do |dc|
  #       dc.register(MyType) { transform(self) }
  #     end
  #
  #     mc.condition_converter.key_converter.configure do |kc|
  #       kc.register(MyKeyType) { normalize_key(self) }
  #     end
  #
  #     mc.condition_converter.value_converter.configure do |vc|
  #       vc.register(MyValueType) { cast_value(self) }
  #     end
  #   end
  #
  # @yieldparam self [Mongory]
  # @return [void]
  def self.configure
    yield self
    data_converter.freeze
    condition_converter.freeze
  end

  # @params klass [Class] the class that you want to add `#mongory` method.
  # @return [void]
  def self.register(klass)
    klass.include(ClassExtention)
  end
  # Implement Symbol snippets like `:name.regex`

  # @return [void]
  def self.enable_symbol_snippets!
    Mongory::QueryOperator::METHOD_TO_OPERATOR_MAPPING.each do |key, operator|
      next if ::Symbol.method_defined?(key)

      ::Symbol.define_method(key) do
        Mongory::QueryOperator.new(to_s, operator)
      end
    end
  end

  # Returns the data converter instance.
  #
  # @return [Converters::DataConverter]
  def self.data_converter
    Converters::DataConverter
  end

  # Returns the condition converter instance.
  #
  # @return [Converters::ConditionConverter]
  def self.condition_converter
    Converters::ConditionConverter
  end

  # Returns the debugger controller.
  #
  # @return [Utils::Debugger]
  def self.debugger
    Utils::Debugger
  end

  # Base class for all Mongory errors.
  class Error < StandardError; end
  class TypeError < Error; end

  # Temp description
  module ClassExtention
    def mongory
      Mongory::QueryBuilder.new(self)
    end
  end
end
