# frozen_string_literal: true

unless Hash.method_defined?(:__expand_complex__)
  # Temp Description
  class Hash
    def __expand_complex__
      each_with_object({}) do |(k, v), result|
        result.merge!(k.__expr_part__(v.__expand_complex__))
      end
    end
  end
end
