# frozen_string_literal: true

require 'mongory/matchers/and_matcher'
require 'mongory/matchers/elem_match_matcher'
require 'mongory/matchers/eq_matcher'
require 'mongory/matchers/exists_matcher'
require 'mongory/matchers/gt_matcher'
require 'mongory/matchers/gte_matcher'
require 'mongory/matchers/hash_matcher'
require 'mongory/matchers/in_matcher'
require 'mongory/matchers/key_value_matcher'
require 'mongory/matchers/lt_matcher'
require 'mongory/matchers/lte_matcher'
require 'mongory/matchers/main_matcher'
require 'mongory/matchers/ne_matcher'
require 'mongory/matchers/nin_matcher'
require 'mongory/matchers/not_matcher'
require 'mongory/matchers/or_matcher'
require 'mongory/matchers/present_matcher'
require 'mongory/matchers/regex_matcher'

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
