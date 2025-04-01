# frozen_string_literal: true

module Mongory
  # Temp Description
  class QueryOperator
    def initialize(name, method_symbol)
      @name = name
      @operator = convert_to_operator(method_symbol)
    end

    def __expr_part__(other)
      { @name => @operator.__expr_part__(other) }
    end

    # Temp Description
    module SingletonMethods
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

      def convert_to_operator(method_symbol)
        check_validity!(METHOD_TO_OPERATOR_MAPPING, method_symbol)
        METHOD_TO_OPERATOR_MAPPING[method_symbol]
      end

      def check_validity!(mapping, target)
        return if mapping.include?(target)

        raise Error, "Invalid operator or method #{target.inspect}"
      end
    end

    extend SingletonMethods
    include SingletonMethods
  end
end
