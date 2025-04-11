# frozen_string_literal: true

module Mongory
  module Utils
    # Only loaded when Rails is present
    module RailsPatch
      def is_present?(target)
        target.present?
      end

      def is_blank?(target)
        target.blank?
      end
    end
  end
end
