# frozen_string_literal: true

unless String.method_defined?(:__expr_part__)
  # Temp Description
  class String
    def __expr_part__(other, *)
      { self => other }
    end
  end
end
