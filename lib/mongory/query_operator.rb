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
      elem_match: '$elemMatch'
    }.freeze

    def initialize(name, operator)
      @name = name
      @operator = operator
    end
  end
end
