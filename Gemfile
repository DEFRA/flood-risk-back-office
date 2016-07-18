# rubocop:disable Metrics/LineLength, Style/ExtraSpacing
source "https://rubygems.org"
ruby "2.3.1"

gem "flood_risk_engine",
    git: "https://github.com/EnvironmentAgency/flood-risk-engine",
    branch: "develop"

gem "rails", "4.2.7"
gem "sass-rails", "~> 5.0.4"    # Use SCSS for stylesheets
gem "uglifier", "~> 3.0"        # Use Uglifier as compressor for JavaScript assets
gem "govuk_admin_template", "~> 4.2.0"
gem "govuk_frontend_toolkit", "~> 4.12.0" # Added this to get Tabs for Choosing Exemption working
gem "govuk_elements_rails", "~> 1.2.1"
gem "simple_form", "~> 3.2.1"
gem "pundit", "~> 1.1.0"
gem "devise", "~> 3.5.10"
gem "devise_invitable", "~> 1.6.0"
gem "devise_security_extension", "~> 0.10.0" # Allows limiting multiple logins to the same account
gem "aws-sdk-resources", "~> 2.3.9" # Amazon S3 API access (e.g. data exports)
gem "before_commit", "~> 0.8"
gem "paper_trail", "~> 5.1.1"
gem "dotenv-rails", "~> 2.1.1"  # Automatically loads environment variables from .env into ENV. Specified here rather than in the group in case any of the gems we add depend on env variables being available.
gem "pg", "~> 0.18.4"           # Use Postgres for the DB
gem "quiet_assets", "~> 1.1.0"  # Mutes assets pipeline log messages
gem "validates_timeliness", "~> 4.0.2" # date/time validator for Rails and ActiveModel
gem "rolify", "~> 5.1.0"
gem "passenger", "~> 5.0.25", require: false # Use Passenger on AWS via Upstart, Heroku via Procfile, and locally via Procfile.development
gem "kaminari", "~> 0.17.0"
gem "squeel", "~> 1.2.3"

group :development, :test do
  gem "factory_girl_rails", "~> 4.6" # also enables "build_dummy_data" functionality in dev
  gem "byebug", "~> 9.0.5"  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "rspec-rails", "~> 3.4.2"
  gem "spring", "~> 1.7.1" # Spring speeds up development by keeping your application running in the background.
  gem "spring-commands-rspec", "~> 1.0.4", require: false # allow spring to wrap the rspec command
  gem "bullet", "~> 5.1.1" # ActiveRecord N+1 detection
  gem "ffaker", "~> 2.2.0"
  gem "faker", "~> 1.6.3"
end

group :development do
  gem "thin", "~> 1.7.0"
  gem "rack-mini-profiler", "~> 0.10.1"
  gem "web-console", "~> 3.0" # Access an IRB console on exception pages or by using <%= console %> in views
  gem "awesome_print", require: false
end

group :test do
  gem "i18n-tasks", "~> 0.9.5"
  gem "capybara", "~> 2.6.2"
  gem "shoulda-matchers", "~> 3.1.1", require: false
  gem "rspec-activemodel-mocks", "~> 1.0.3"
  gem "poltergeist", "~> 1.9.0" # Needed for headless testing with Javascript or pages that ref external sites
  gem "launchy", require: false # save_and_open_page
  gem "database_cleaner", "~> 1.5.1"
  gem "fuubar" # Enhanced rspec progress formatter
  gem "rspec_junit_formatter", "~> 0.2.3" # For CircleCI metadata reports
  gem "simplecov", "~> 0.11.2", require: false # Tool for checking code coverage
  gem "email_spec", "~> 2.1.0"
end

group :production do
  gem "whenever", "~> 0.9.6" # for creating chron jobs
  gem "rails_12factor", "~> 0.0.3" # Useful if deploying to Heroku
  gem "airbrake", "~> 5.3.0" # Airbrake catches exceptions, sends them to https://dst-errbit.herokuapp.com
end
