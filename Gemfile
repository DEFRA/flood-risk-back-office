source "https://rubygems.org"
ruby "2.3.1"

# Amazon S3 API access (e.g. data exports)
gem "aws-sdk-resources", "~> 2.3.9"
gem "devise", "~> 3.5.10"
gem "devise_invitable", "~> 1.6.0"
# Allows limiting multiple logins to the same account
gem "devise_security_extension", "~> 0.10.0"
gem "govuk_admin_template", "~> 4.2.0"
gem "govuk_elements_rails", "~> 1.2.1"
# Added this to get Tabs for Choosing Exemption working
gem "govuk_frontend_toolkit", "~> 4.12.0"
# A Scope & Engine based paginator for Ruby webapps
gem "kaminari", "~> 0.17.0"
gem "paper_trail", "~> 5.1.1"
# Use Postgres for the DB
gem "pg", "~> 0.18.4"
gem "pundit", "~> 1.1.0"
# Mutes assets pipeline log messages
gem "quiet_assets", "~> 1.1.0"
gem "rails", "~> 4.2"
gem "rolify", "~> 5.1.0"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0.4"
gem "simple_form", "~> 3.2.1"
gem "squeel", "~> 1.2.3"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", "~> 3.0"
# date/time validator for Rails and ActiveModel
gem "validates_timeliness", "~> 4.0.2"
# Gem that provides a clear syntax for writing and deploying cron jobs.
gem "whenever", "~> 0.9.4", require: false

gem "flood_risk_engine",
    git: "https://github.com/DEFRA/flood-risk-engine",
    branch: "master"

# Automatically loads environment variables from .env into ENV. Specified here
# rather than in the group in case any of the gems we add depend on env
# variables being available
gem "dotenv-rails", "~> 2.1.1", groups: [:development, :test]

group :development do
  # Pretty prints objects in console. Usage `$ ap some_object`
  gem "awesome_print"
  # Used to ensure the code base matches our agreed styles and conventions
  gem "rubocop", "~> 0.47"
end

group :development, :test do
  # ActiveRecord N+1 detection
  gem "bullet"
  # Call 'byebug' anywhere in the code to stop execution and get a debugger
  # console
  gem "byebug"
  # Provides Rails integration for factory_bot. Enables "build_dummy_data"
  # functionality in dev
  gem "factory_bot_rails", "~> 4.6"
  # Used to generate fake data e.g. in the specs
  gem "faker", "~> 1.7"
  # A testing framework for Rails 3.x, 4.x and 5.0
  gem "rspec-rails", "~> 3.4.2"
end

group :test do
  gem "capybara", "~> 2.6.2"
  gem "database_cleaner", "~> 1.5.1"
  gem "email_spec", "~> 2.1.0"
  # Enhanced rspec progress formatter
  gem "fuubar"
  # save_and_open_page
  gem "launchy", require: false
  # Needed for headless testing with Javascript or pages that ref external sites
  gem "poltergeist", "~> 1.9.0"
  gem "rspec-activemodel-mocks", "~> 1.0.3"
  # For CircleCI metadata reports
  gem "rspec_junit_formatter", "~> 0.2.3"
  gem "shoulda-matchers", "~> 3.1.1", require: false
  # Tool for checking code coverage
  gem "simplecov", "~> 0.11.2", require: false
end

group :production do
  # Airbrake catches exceptions, sends them to https://dst-errbit.herokuapp.com
  gem "airbrake", "~> 5.3.0"
  # Use Passenger as our web-server/app-server (e.g. on AWS via Upstart, Heroku
  # via Procfile)	  # via Procfile)
  gem "passenger", "~> 5.0", ">= 5.0.30", require: "phusion_passenger/rack_handler"
end
