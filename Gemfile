source "https://rubygems.org"
ruby "3.2.2"

gem "aws-sdk-s3"
gem "devise"
gem "devise_invitable"
gem "devise-security"
gem "faraday"
gem "faraday-retry"
gem "jquery-rails", "~> 4.4"
gem "kaminari"
gem "net-imap", require: false
gem "net-pop", require: false
gem "net-smtp", require: false
gem "paper_trail"
gem "pg"
gem "pundit"
gem "rolify"
gem "sass-rails"
gem "secure_headers"

gem "record_tag_helper" # supports the deprecated `content_tag_for`
gem "uglifier"
gem "whenever"

gem "flood_risk_engine",
    git: "https://github.com/DEFRA/flood-risk-engine",
    branch: "main"

# This is specified in the engine gemspec,
# but need to specify here also to pick up i18n locales
# Pin to below v3 to avoid pulling in the companies house gem
gem "defra_ruby_validators", "~> 2.7"

gem "defra_ruby_aws"
gem "defra_ruby_template", "~> 5.11"
gem "github_changelog_generator", require: false
gem "govuk_design_system_formbuilder"
# GOV.UK Notify gem. Allows us to send email via the Notify web API
gem "notifications-ruby-client"

gem "dotenv-rails"

# for handling Water Managment Areas GeoJSON data
gem "rgeo-geojson"
gem "rubyzip"

group :development do
  gem "awesome_print"
  gem "defra_ruby_style"
  gem "puma"
  gem "rubocop-capybara"
  gem "rubocop-factory_bot"
  gem "rubocop-rails"
  gem "rubocop-rspec"
  gem "rubocop-rspec_rails"
end

group :development, :test do
  gem "bullet"
  gem "byebug"
end

group :test do
  gem "capybara"
  gem "database_cleaner"
  gem "email_spec", require: false
  gem "factory_bot_rails"
  gem "faker"
  gem "fuubar"
  gem "launchy", require: false
  gem "poltergeist"
  gem "rspec"
  gem "rspec-activemodel-mocks"
  gem "rspec-core"
  gem "rspec_junit_formatter"
  gem "rspec-rails"
  gem "rspec-retry"
  gem "shoulda-matchers", "~> 3.1.1", require: false # Pinned to avoid breaking changes
  gem "simplecov", "~> 0.17.1", require: false
  gem "vcr"
  gem "webmock"
  gem "whenever-test", "~> 1.0"
end

# Pin this version as well as passenger to avoid https://github.com/phusion/passenger/issues/2508
gem "rack", "2.2.4"

group :production do
  # Use Passenger as our web-server/app-server (e.g. on AWS via Upstart, Heroku
  # via Procfile) # via Procfile)
  # Pin this version as well as rack to avoid https://github.com/phusion/passenger/issues/2508
  gem "passenger", "6.0.19", require: "phusion_passenger/rack_handler"
end
