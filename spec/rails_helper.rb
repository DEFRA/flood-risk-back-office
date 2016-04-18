# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "spec_helper"
require "rspec/rails"
require "capybara/poltergeist"
require "shoulda/matchers"
require "support/factory_girl"
require "support/database_cleaner"
require "support/shoulda"
require "support/matchers/have_flash"
require "support/matchers/have_form_error"

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  ActiveRecord::Migration.maintain_test_schema!

  config.include Warden::Test::Helpers, type: :feature
  config.include ActiveSupport::Testing::TimeHelpers
  config.include AbstractController::Translation # enables t()
end
