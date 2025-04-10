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
# Provides access to core converters, query construction, and optional
# integrations with frameworks like Rails or Mongoid.
#
# @example Basic usage
#   Mongory.build_query(records).where(age: { :$gt => 18 })
#
# @example Enabling DSL snippets
#   Mongory.enable_symbol_snippets!
#   Mongory.register(Array)
module Mongory
  class Error < StandardError; end
  class TypeError < Error; end

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

  # Returns the debugger instance.
  #
  # @return [Utils::Debugger]
  def self.debugger
    Utils::Debugger
  end

  # Builds a new query over the given record set.
  #
  # @param records [Enumerable] any enumerable object (Array, AR::Relation, etc.)
  # @return [QueryBuilder] a new query builder
  def self.build_query(records)
    QueryBuilder.new(records)
  end

  # Registers a class to support `.mongory` query DSL.
  # This injects a `#mongory` method into the given class.
  #
  # @param klass [Class] the class to register (e.g., Array, ActiveRecord::Relation)
  # @return [void]
  def self.register(klass)
    klass.include(ClassExtention)
  end

  # Enables symbol snippets like `:age.gte` or `:name.regex`
  # by dynamically defining methods on `Symbol` for query operators.
  #
  # Skips operators that already exist to avoid patching Mongoid or other gems.
  #
  # @return [void]
  def self.enable_symbol_snippets!
    Mongory::QueryOperator::METHOD_TO_OPERATOR_MAPPING.each do |key, operator|
      next if ::Symbol.method_defined?(key)

      ::Symbol.define_method(key) do
        Mongory::QueryOperator.new(to_s, operator)
      end
    end
  end

  # Adds a `#mongory` method to the target class via inclusion.
  #
  # Typically used internally by `Mongory.register(...)`.
  module ClassExtention
    # Returns a query builder scoped to `self`.
    #
    # @return [QueryBuilder]
    def mongory
      Mongory::QueryBuilder.new(self)
    end
  end
end
