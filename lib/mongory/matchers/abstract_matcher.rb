# frozen_string_literal: true

require 'mongory/utils'

module Mongory
  # Temp Description
  module Matchers
    # Abstract class
    class AbstractMatcher
      include Mongory::Utils

      KEY_NOT_FOUND = Object.new

      def self.define_matcher(name, &block)
        define_instance_cache_method(:"#{name}_matcher", &block)
      end

      def initialize(condition)
        @condition = condition
        check_validity!
      end

      def match?(*); end

      private

      def check_validity!; end

      def normalize(record)
        record == KEY_NOT_FOUND ? nil : record
      end
    end
  end
end
