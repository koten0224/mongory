# frozen_string_literal: true

%i(eq ne not and or regex present exists gt gte lt lte in nin elem_match).each do |key|
  next if Symbol.method_defined?(key)

  Symbol.define_method(key) do
    Mongory::QueryOperator.new(self, key)
  end
end
