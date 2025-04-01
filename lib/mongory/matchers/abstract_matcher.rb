# frozen_string_literal: true

require 'mongory/utils'

module Mongory
  # Temp Description
  module Matchers
    # Abstract class
    class AbstractMatcher
      include Mongory::Utils

      KEY_NOT_FOUND = Object.new

      def initialize(condition)
        check_validity!(condition)
        @condition = condition
      end

      def match?(*); end
      def check_validity!(*); end

      def normalize(record)
        record == KEY_NOT_FOUND ? nil : record
      end
    end
  end
end
