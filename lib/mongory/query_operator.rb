# frozen_string_literal: true

module Mongory
  # Temp Description
  class QueryOperator
    METHOD_TO_OPERATOR_MAPPING = {
      eq: '$eq',
      ne: '$ne',
      not: '$not',
      and: '$and',
      or: '$or',
      regex: '$regex',
      present: '$present',
      exists: '$exists',
      gt: '$gt',
      gte: '$gte',
      lt: '$lt',
      lte: '$lte',
      in: '$in',
      nin: '$nin',
      elem_match: '$elemMatch',
      every: '$every'
    }.freeze

    def initialize(name, operator)
      @name = name
      @operator = operator
    end

    def __expr_part__(other, *)
      Converters::KeyConverter.convert(@name, @operator => other)
    end
  end
end
