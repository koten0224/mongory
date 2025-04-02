# frozen_string_literal: true

require 'date'

module Mongory
  # Temp Description
  module Utils
    def self.included(base)
      base.extend(ClassMethods)
      super
    end

    def deep_convert(obj)
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

    # Temp Description
    module ClassMethods
      def define_instance_cache_method(name, &block)
        instance_key = :"@#{name}"
        define_method(name) do
          return instance_variable_get(instance_key) if instance_variable_defined?(instance_key)

          instance_variable_set(instance_key, instance_exec(&block))
        end
      end
    end
  end
end
