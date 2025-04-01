# frozen_string_literal: true

unless Object.method_defined?(:__expand_complex__)
  # Temp Description
  class Object
    def __expand_complex__
      self
    end
  end
end
