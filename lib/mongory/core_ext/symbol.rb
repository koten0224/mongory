# frozen_string_literal: true

Mongory::QueryOperator::METHOD_TO_OPERATOR_MAPPING.each do |key, operator|
  next if Symbol.method_defined?(key)

  Symbol.define_method(key) do
    Mongory::QueryOperator.new(self, operator)
  end
end

unless Symbol.method_defined?(:__expr_part__)
  # Temp Description
  class Symbol
    def __expr_part__(other, *)
      { self => other }
    end
  end
end
