# frozen_string_literal: true

require_relative 'utils'

module Mongory
  # Temp Description
  class QueryMatcher < Matchers::DefaultMatcher
    include Mongory::Utils

    def initialize(condition)
      super(Mongory.condition_converter.convert(condition))
    end
  end
end
