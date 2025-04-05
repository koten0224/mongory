# frozen_string_literal: true

require_relative 'utils'

module Mongory
  # Temp Description
  class QueryMatcher < Matchers::DefaultMatcher
    include Mongory::Utils

    def initialize(condition)
      super(deep_convert_condition(condition.__expand_complex__))
    end

    private

    def deep_convert_condition(obj)
      case obj
      when Hash
        convert_hash(obj)
      when Array
        obj.map { |v| deep_convert_condition(v) }
      when Regexp
        { '$regex' => obj.source }
      else
        DataConverter.convert(obj)
      end
    end

    def convert_hash(hash)
      hash.each_with_object({}) do |(k, v), result|
        *keys, last_key = k.to_s.split('.')
        last_hash = keys.reduce(result) do |res, key|
          res[key] ||= {}
        end
        last_hash[last_key] = deep_convert_condition(v)
      end
    end
  end
end
