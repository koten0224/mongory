# frozen_string_literal: true

require 'date'

module Mongory
  # Temp Description
  module Utils
    def deep_convert(obj)
      return obj.as_json if obj.respond_to?(:as_json)

      case obj
      when Hash
        obj.each_with_object({}) do |(k, v), result|
          result[k.to_s] = deep_convert(v)
        end
      when Array
        obj.map { |v| deep_convert(v) }
      when Symbol, Date
        obj.to_s
      when Time, DateTime
        obj.iso8601
      when Regexp
        { '$regex' => obj.source }
      else
        obj
      end
    end

    def present?(obj)
      !blank?(obj)
    end

    def blank?(obj)
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
end
