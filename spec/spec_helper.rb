# frozen_string_literal: true

require 'mongory'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  def converter_deep_dup(converter)
    converter = converter.dup
    converter.instance_exec do
      @registries = @registries.dup
      @fallback = @fallback.dup
    end
    converter
  end

  def enforce_reset_converter(method, converter)
    Mongory.define_singleton_method(method) { converter }
  end

  Mongory.enable_symbol_snippets!
  Mongory.register(Array)
end
