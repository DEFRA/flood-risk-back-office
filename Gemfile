source "https://rubygems.org"
ruby "2.3.1"

# Amazon S3 API access (e.g. data exports)
gem "aws-sdk-resources", "~> 2.3.9"
gem "devise", "~> 3.5.10"
gem "devise_invitable", "~> 1.6.0"
# Allows limiting multiple logins to the same account
gem "devise_security_extension", "~> 0.10.0"
# Automatically loads environment variables from .env into ENV. Specified here
# rather than in the group in case any of the gems we add depend on env
# variables being available
gem "dotenv-rails", "~> 2.1.1"

gem "flood_risk_engine",
    git: "https://github.com/DEFRA/flood-risk-engine",
    tag: "v1.0.2"

gem "govuk_admin_template", "~> 4.2.0"
gem "govuk_elements_rails", "~> 1.2.1"
# Added this to get Tabs for Choosing Exemption working
gem "govuk_frontend_toolkit", "~> 4.12.0"
gem "kaminari", "~> 0.17.0"
gem "paper_trail", "~> 5.1.1"
# Use Passenger on AWS via Upstart, Heroku via Procfile, and locally via
# Procfile.development
gem "passenger", "~> 5.0.25", require: false
# Use Postgres for the DB
gem "pg", "~> 0.18.4"
gem "pundit", "~> 1.1.0"
# Mutes assets pipeline log messages
gem "quiet_assets", "~> 1.1.0"
gem "rails", "4.2.7"
gem "rolify", "~> 5.1.0"
# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0.4"
gem "simple_form", "~> 3.2.1"
gem "squeel", "~> 1.2.3"
# Use Uglifier as compressor for JavaScript assets
gem "uglifier", "~> 3.0"
# date/time validator for Rails and ActiveModel
gem "validates_timeliness", "~> 4.0.2"

group :development, :test do
  # also enables "build_dummy_data" functionality in dev
  gem "factory_girl_rails", "~> 4.6"
  # Call 'byebug' anywhere in the code to stop execution and get a debugger
  # console
  gem "byebug", "~> 9.0.5"
  gem "rspec-rails", "~> 3.4.2"
  # Spring speeds up development by keeping your application running in the
  # background
  gem "spring", "~> 1.7.1"
  # allow spring to wrap the rspec command
  gem "spring-commands-rspec", "~> 1.0.4", require: false
  # ActiveRecord N+1 detection
  gem "bullet", "~> 5.1.1"
  gem "faker", "~> 1.6.3"
  # Ensure we are meeting agreed style and consistency rules in the project
  gem "rubocop", "~> 0.45.0"
end

group :development do
  gem "awesome_print", require: false
  gem "rack-mini-profiler", "~> 0.10.1"
  gem "thin", "~> 1.7.0"
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem "web-console", "~> 3.0"
end

group :test do
  gem "capybara", "~> 2.6.2"
  gem "database_cleaner", "~> 1.5.1"
  gem "email_spec", "~> 2.1.0"
  # Enhanced rspec progress formatter
  gem "fuubar"
  gem "i18n-tasks", "~> 0.9.5"
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
  # Useful if deploying to Heroku
  gem "rails_12factor", "~> 0.0.3"
  # for creating chron jobs
  gem "whenever", "~> 0.9.6"
end
