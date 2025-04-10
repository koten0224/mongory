# lib/generators/mongory/install/install_generator.rb
# frozen_string_literal: true

require 'bundler'

module Mongory
  module Generators
    # Temp description
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def create_initializer_file
        @use_ar       = gem_used?('activerecord')
        @use_mongoid  = gem_used?('mongoid')
        @use_sequel   = gem_used?('sequel')

        template 'initializer.rb.erb', 'config/initializers/mongory.rb'
      end

      private

      def gem_used?(gem_name)
        Bundler.locked_gems.dependencies.key?(gem_name)
      end
    end
  end
end
