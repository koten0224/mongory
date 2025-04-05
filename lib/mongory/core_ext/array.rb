# frozen_string_literal: true

# Temp Description
class Array
  def mongory
    Mongory.build_query(self)
  end
end
