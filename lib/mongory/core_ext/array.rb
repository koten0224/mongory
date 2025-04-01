# frozen_string_literal: true

class Array
  def mongory
    Mongory.build_query(self)
  end

  unless method_defined?(:__expand_complex__)
    def __expand_complex__
      map do |v|
        v.__expand_complex__
      end
    end
  end
end
