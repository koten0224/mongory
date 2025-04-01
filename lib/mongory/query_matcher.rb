# frozen_string_literal: true

module Mongory
  # Temp Description
  class QueryMatcher
    KEY_NOT_FOUND = Object.new
    BOOLEAN_VALUES = [true, false].freeze

    def initialize(condition)
      @condition = Mongory::Utils.deep_convert(condition.__expand_complex__)
      @matcher = build_base_matcher(@condition)
    end

    def match?(record)
      @matcher.call(Mongory::Utils.deep_convert(record))
    end

    private

    def build_base_matcher(condition)
      hash_matcher = nil

      ::Proc.new do |record|
        if condition == record
          true
        elsif condition.is_a?(Hash)
          hash_matcher ||= build_hash_matcher(condition)
          hash_matcher.call(record)
        elsif record.is_a?(Array) # and condition not a hash
          record.include?(condition)
        else
          false
        end
      end
    end

    def build_hash_matcher(condition)
      matchers = condition.map do |k, v|
        build_hash_sub_matcher(k, v)
      end

      ::Proc.new do |record|
        matchers.all? do |matcher|
          matcher.call(record)
        end
      end
    end

    def build_hash_sub_matcher(match_key, match_value)
      elem_matcher = nil
      base_matcher = nil

      begin
        method_name = :"build_matcher_#{Mongory::QueryOperator.convert_to_method(match_key)}"
        return send(method_name, match_value)
      rescue Mongory::Error
      end

      ::Proc.new do |record|
        record_sub_value = fetch_value(record, match_key)

        if record.is_a?(Array) && record_sub_value.nil?
          elem_matcher ||= build_matcher_elem_match(match_key => match_value)
          elem_matcher.call(record)
        else
          base_matcher ||= build_base_matcher(match_value)
          base_matcher.call(record_sub_value)
        end
      end
    end

    def build_matcher_present(match_value)
      raise TypeError, '$present needs a boolean' unless BOOLEAN_VALUES.include?(match_value)

      ::Proc.new do |record|
        Mongory::Utils.present?(normalize_key(record)) == match_value
      end
    end

    def build_matcher_exists(match_value)
      raise TypeError, '$exists needs a boolean' unless BOOLEAN_VALUES.include?(match_value)

      ::Proc.new do |record|
        (record != KEY_NOT_FOUND) == match_value
      end
    end

    def build_matcher_and(conditions)
      raise TypeError, '$and needs an array' unless conditions.is_a?(Array)

      build_with_base_matcher(conditions, :all?)
    end

    def build_matcher_or(conditions)
      raise TypeError, '$or needs an array' unless conditions.is_a?(Array)

      build_with_base_matcher(conditions, :any?)
    end

    def build_with_base_matcher(conditions, operator)
      matchers = conditions.map do |condition|
        build_base_matcher(condition)
      end

      ::Proc.new do |record|
        record = normalize_key(record)

        matchers.send(operator) do |matcher|
          matcher.call(record)
        end
      end
    end

    def build_matcher_regex(match_value)
      raise TypeError, '$regex needs a string' unless match_value.is_a?(String)

      ::Proc.new do |record|
        return false unless record.is_a?(String)

        record.match?(match_value)
      rescue StandardError
        false
      end
    end

    def build_matcher_not(condition)
      base_matcher = build_base_matcher(condition)

      ::Proc.new do |record|
        !base_matcher.call(normalize_key(record))
      end
    end

    def build_matcher_eq(match_value)
      ::Proc.new do |record|
        match_value == normalize_key(record)
      end
    end

    def build_matcher_ne(match_value)
      ::Proc.new do |record|
        match_value != normalize_key(record)
      end
    end

    def build_matcher_gt(match_value)
      build_operator_matcher(:>, match_value)
    end

    def build_matcher_gte(match_value)
      build_operator_matcher(:>=, match_value)
    end

    def build_matcher_lt(match_value)
      build_operator_matcher(:<, match_value)
    end

    def build_matcher_lte(match_value)
      build_operator_matcher(:<=, match_value)
    end

    def build_operator_matcher(operator, match_value)
      ::Proc.new do |record|
        if record == KEY_NOT_FOUND
          false
        else
          record.send(operator, match_value)
        end
      rescue StandardError
        false
      end
    end

    def build_matcher_in(match_value)
      raise TypeError, '$in needs an array' unless match_value.is_a?(Array)

      ::Proc.new do |record|
        Mongory::Utils.present?(match_value & Array(normalize_key(record)))
      end
    end

    def build_matcher_nin(match_value)
      raise TypeError, '$nin needs an array' unless match_value.is_a?(Array)

      ::Proc.new do |record|
        Mongory::Utils.blank?(match_value & Array(normalize_key(record)))
      end
    end

    def build_matcher_elem_match(condition)
      matcher = build_base_matcher(condition)

      ::Proc.new do |record|
        if record.is_a?(Array)
          record.any? do |value|
            matcher.call(value)
          end
        else
          false
        end
      end
    end

    def normalize_key(record)
      record == KEY_NOT_FOUND ? nil : record
    end

    def fetch_value(record, key)
      case record
      when Hash
        record.fetch(key, KEY_NOT_FOUND)
      when Array
        return unless key.match?(/^\d+$/)

        record[key.to_i]
      end
    end
  end
end
