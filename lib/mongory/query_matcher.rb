# frozen_string_literal: true

require_relative 'utils'

module Mongory
  # The top-level matcher for compiled query conditions.
  #
  # Delegates to {Matchers::DefaultMatcher} after transforming input
  # via {Converters::ConditionConverter}.
  #
  # Typically used internally by `QueryBuilder`.
  #
  # @example
  #   matcher = QueryMatcher.build({ :age.gte => 18 })
  #   matcher.match?(record)
  #
  # @see Matchers::DefaultMatcher
  # @see Converters::ConditionConverter
  class QueryMatcher < Matchers::DefaultMatcher
    # @param condition [Hash] the raw user query
    def initialize(condition)
      super(Mongory.condition_converter.convert(condition))
    end
  end
end
