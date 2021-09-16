source "https://rubygems.org"
ruby "2.7.1"

gem "aws-sdk-resources"
gem "devise"
gem "devise_invitable"
gem "devise-security"
gem "jquery-rails"
gem "kaminari"
gem "paper_trail"
gem "pg"
gem "pundit"
gem "rails", "~> 6.0.3"
gem "rolify"
gem "sass-rails"
gem "simple_form"

gem "record_tag_helper" # supports the deprecated `content_tag_for`
gem "uglifier"
gem "validates_timeliness"
gem "whenever"

gem "flood_risk_engine",
    git: "https://github.com/DEFRA/flood-risk-engine",
    branch: "rails6"

gem "defra_ruby_aws"
gem "defra_ruby_email"
gem "defra_ruby_template"
gem "github_changelog_generator", require: false
gem "govuk_design_system_formbuilder"

gem "dotenv-rails"

# This has been removed from the engine so re-adding here temporarily
# until we refactor it out of all the admin forms
gem "reform", "~> 2.6"
gem "reform-rails", "~> 0.2.2"

group :development do
  gem "awesome_print"
  gem "rubocop"
end

group :development, :test do
  gem "bullet"
  gem "byebug"
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
end

group :test do
  gem "capybara"
  gem "database_cleaner"
  gem "email_spec"
  gem "fuubar"
  gem "launchy", require: false
  gem "poltergeist"
  gem "rails-controller-testing"
  gem "rspec-activemodel-mocks"
  gem "rspec_junit_formatter"
  gem "shoulda-matchers", "~> 3.1.1", require: false # Pinned to avoid breaking changes
  gem "simplecov", "~> 0.17.1", require: false
end

group :production do
  # Use Passenger as our web-server/app-server (e.g. on AWS via Upstart, Heroku
  # via Procfile) # via Procfile)
  gem "passenger", require: "phusion_passenger/rack_handler"
end
