# frozen_string_literal: true

require 'date'

module Mongory
  # Temp Description
  module Utils
    # Temp Description
    module SingletonMethods
      def deep_convert(obj = self)
        case obj
        when Hash
          obj.each_with_object({}) do |(k, v), result|
            result[k.to_s] = deep_convert(v)
          end
        when Array
          obj.map { |v| deep_convert(v) }
        when Symbol
          obj.to_s
        when Regexp
          { '$regex' => obj.source }
        when Time, DateTime
          obj.iso8601
        when Date
          obj.to_s
        else
          obj
        end
      end

      def present?(obj = self)
        !blank?(obj)
      end

      def blank?(obj = self)
        case obj
        when false, nil
          true
        when Hash, Array, String
          obj.empty?
        else
          false
        end
      end
    end

    extend SingletonMethods
    include SingletonMethods
  end
end
