# frozen_string_literal: true

require_relative "mongory/version"
require_relative "mongory/utils"
require_relative "mongory/query_matcher"
require_relative "mongory/query_builder"
require_relative "mongory/query_operator"
require_relative "mongory/core_ext"

module Mongory
  def self.build_query(records)
    Mongory::QueryBuilder.new(records)
  end

  class Error < StandardError; end
end
