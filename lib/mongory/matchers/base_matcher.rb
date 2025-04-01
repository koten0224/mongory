# frozen_string_literal: true

require 'mongory/utils'

module Mongory
  # Temp Description
  module Matchers
    # Abstract class
    class BaseMatcher
      include Mongory::Utils

      KEY_NOT_FOUND = Object.new

      def initialize(condition)
        check_validity!(condition)
        @condition = condition
      end

      def match?(*); end
      def check_validity!(*); end

      def normalize_key(record)
        record == KEY_NOT_FOUND ? nil : record
      end

      def fetch_value(record, key)
        case record
        when Hash
          record.fetch(key, KEY_NOT_FOUND)
        when Array
          return record[key.to_i] if key.match?(/^\d+$/) && record.length > key.to_i

          KEY_NOT_FOUND
        end
      end
    end
  end
end
