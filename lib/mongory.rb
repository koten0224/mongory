# frozen_string_literal: true

require 'time'
require 'date'
require_relative 'mongory/version'
require_relative 'mongory/config'
require_relative 'mongory/utils'
require_relative 'mongory/data_converter'
require_relative 'mongory/matchers'
require_relative 'mongory/query_matcher'
require_relative 'mongory/query_builder'
require_relative 'mongory/query_operator'
require_relative 'mongory/core_ext'

# Temp Description
module Mongory
  def self.build_query(records)
    QueryBuilder.new(records)
  end

  def self.configure
    yield config
  end

  def self.config
    Config
  end

  def self.data_converter
    DataConverter
  end

  class Error < StandardError; end
end
