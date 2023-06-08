source "https://rubygems.org"
ruby "3.2.2"

gem "aws-sdk-s3"
gem "devise"
gem "devise_invitable"
gem "devise-security"
gem "jquery-rails", "~> 4.4"
gem "kaminari"
gem "net-imap", require: false
gem "net-pop", require: false
gem "net-smtp", require: false
gem "paper_trail"
gem "pg"
gem "pundit"
gem "rails", "~> 7.0"
gem "rolify"
gem "sass-rails"
gem "secure_headers"

gem "record_tag_helper" # supports the deprecated `content_tag_for`
gem "uglifier"
gem "whenever"

gem "flood_risk_engine",
    git: "https://github.com/DEFRA/flood-risk-engine",
    branch: "main"

gem "defra_ruby_aws"
gem "defra_ruby_email"
gem "defra_ruby_template"
gem "github_changelog_generator", require: false
gem "govuk_design_system_formbuilder"
# GOV.UK Notify gem. Allows us to send email via the Notify web API
gem "notifications-ruby-client"

gem "dotenv-rails"

group :development do
  gem "awesome_print"
  gem "defra_ruby_style"
  gem "puma"
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
  gem "email_spec", require: false
  gem "fuubar"
  gem "launchy", require: false
  gem "poltergeist"
  gem "rspec-activemodel-mocks"
  gem "rspec_junit_formatter"
  gem "rubocop-rails"
  gem "rubocop-rspec"
  gem "shoulda-matchers", "~> 3.1.1", require: false # Pinned to avoid breaking changes
  gem "simplecov", "~> 0.17.1", require: false
  gem "vcr"
  gem "webmock"
  gem "whenever-test", "~> 1.0"
end

group :production do
  # Use Passenger as our web-server/app-server (e.g. on AWS via Upstart, Heroku
  # via Procfile) # via Procfile)
  gem "passenger", require: "phusion_passenger/rack_handler"
end
