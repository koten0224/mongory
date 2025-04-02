# frozen_string_literal: true

module Mongory
  # Temp Description
  class Config
    attr_accessor :data_converter

    def initialize
      @data_converter = :as_json
    end
  end
end
