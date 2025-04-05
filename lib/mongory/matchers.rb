# frozen_string_literal: true

require_relative 'matchers/abstract_matcher'
require_relative 'matchers/abstract_multi_matcher'
require_relative 'matchers/abstract_operator_matcher'
require_relative 'matchers/main_matcher'
require_relative 'matchers/and_matcher'
require_relative 'matchers/collection_matcher'
require_relative 'matchers/elem_match_matcher'
require_relative 'matchers/eq_matcher'
require_relative 'matchers/exists_matcher'
require_relative 'matchers/gt_matcher'
require_relative 'matchers/gte_matcher'
require_relative 'matchers/condition_matcher'
require_relative 'matchers/in_matcher'
require_relative 'matchers/dig_value_matcher'
require_relative 'matchers/lt_matcher'
require_relative 'matchers/lte_matcher'
require_relative 'matchers/ne_matcher'
require_relative 'matchers/nin_matcher'
require_relative 'matchers/not_matcher'
require_relative 'matchers/or_matcher'
require_relative 'matchers/present_matcher'
require_relative 'matchers/regex_matcher'

module Mongory
  # Temp Description
  module Matchers
    OPERATOR_TO_CLASS_MAPPING = {
      '$eq' => :EqMatcher,
      '$ne' => :NeMatcher,
      '$not' => :NotMatcher,
      '$and' => :AndMatcher,
      '$or' => :OrMatcher,
      '$regex' => :RegexMatcher,
      '$present' => :PresentMatcher,
      '$exists' => :ExistsMatcher,
      '$gt' => :GtMatcher,
      '$gte' => :GteMatcher,
      '$lt' => :LtMatcher,
      '$lte' => :LteMatcher,
      '$in' => :InMatcher,
      '$nin' => :NinMatcher,
      '$elemMatch' => :ElemMatchMatcher
    }.freeze

    def self.lookup(key)
      return unless OPERATOR_TO_CLASS_MAPPING.include?(key)

      const_get(OPERATOR_TO_CLASS_MAPPING[key])
    end
  end
end
