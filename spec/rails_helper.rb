# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "spec_helper"
require "rspec/rails"
require "capybara/poltergeist"
require "shoulda/matchers"
require "support/factory_bot"
require "support/shoulda"
require "support/matchers/have_flash"
require "support/matchers/have_form_error"

Capybara.javascript_driver = :poltergeist

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  ActiveRecord::Migration.maintain_test_schema!

  config.include Warden::Test::Helpers, type: :feature
  config.include ActiveSupport::Testing::TimeHelpers
  config.include AbstractController::Translation # enables t()

  # Allows us to include should matchers like validate_presence_of if the spec type
  # is :form (already works out of the box but only for type :model)
  config.include(Shoulda::Matchers::ActiveModel, type: :form)

  config.use_transactional_fixtures = false
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
