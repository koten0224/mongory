# frozen_string_literal: true

Mongory::QueryOperator::METHOD_TO_OPERATOR_MAPPING.each do |key, operator|
  next if Symbol.method_defined?(key)

  Symbol.define_method(key) do
    Mongory::QueryOperator.new(to_s, operator)
  end
end
