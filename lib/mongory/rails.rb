# frozen_string_literal: true

require 'rails'
require_relative 'utils/rails_patch'

module Mongory
  # @see Utils::RailsPatch
  class Railtie < Rails::Railtie
    initializer 'mongory.patch_utils' do
      Mongory::Utils.prepend(Mongory::Utils::RailsPatch)
    end
  end
end
