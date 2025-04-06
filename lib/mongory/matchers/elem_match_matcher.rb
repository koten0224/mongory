# frozen_string_literal: true

module Mongory
  # Temp Description
  module Matchers
    # Temp Description
    class ElemMatchMatcher < DefaultMatcher
      def match?(collection)
        return false unless collection.is_a?(Array)

        collection.any? do |record|
          super(record)
        end
      end
    end
  end
end
