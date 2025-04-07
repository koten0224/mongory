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
require_relative 'mongory/core_ext'

# Temp Description
module Mongory
  def self.build_query(records)
    QueryBuilder.new(records)
  end

  def self.configure
    yield self
    data_converter.freeze
    condition_converter.freeze
  end

  def self.data_converter
    Converters::DataConverter
  end

  def self.condition_converter
    Converters::ConditionConverter
  end

  def self.debugger
    Utils::Debugger
  end

  class Error < StandardError; end
end
