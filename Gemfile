source "https://rubygems.org"
ruby "2.3.1"

gem "rails", "4.2.6"
gem "sass-rails", "~> 5.0"    # Use SCSS for stylesheets
gem "uglifier", "~> 3.0"      # Use Uglifier as compressor for JavaScript assets
gem "coffee-rails", "~> 4.1"  # Use CoffeeScript for .coffee assets and views
gem "govuk_admin_template", "~> 4.1"
gem "govuk_frontend_toolkit", "~> 4.9" # Added this to get Tabs for Choosing Exemption working
gem "simple_form", "~> 3.2"
gem "pundit", "~> 1.1"
gem "devise", "~> 3.5"
gem "devise_invitable", "~> 1.5"
gem "aws-sdk-resources", "~> 2.2" # Amazon S3 API access (e.g. data exports)
gem "before_commit"
gem "paper_trail", "~> 5.1.1"

gem "flood_risk_engine",
    git: "https://github.com/EnvironmentAgency/flood-risk-engine",
    branch: "develop"

# Automatically loads environment variables from .env into ENV. Specified here
# rather than in the group in case any of the gems we add depend on env
# variables being available.
gem "dotenv-rails" # , groups: [:development, :test]

gem "pg", "~> 0.18.4"           # Use Postgres for the DB
gem "quiet_assets", "~> 1.1.0"  # Mutes assets pipeline log messages
gem "textacular", "~> 3.2.2"    # Postgres free-text search utilities
gem "scenic", "~> 1.3.0" # Versioned database views for Rails
# instances with optional information about types - used in Presenters
gem "validates_timeliness", "~> 4.0.2" # date/time validator for Rails and ActiveModel
gem "rolify", "~> 5.0"
# Use Passenger as our web-server/app-server
# (e.g. on AWS via Upstart, Heroku vi Procfile, and locally via Procfile.development
gem "passenger", "~> 5.0.25", require: false
gem "kaminari", "~> 0.16"

group :development, :test do
  gem "factory_girl_rails", "~> 4.6" # also enables "build_dummy_data" functionality in dev
  gem "byebug"  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "rspec-rails", "~> 3.4.2"
  gem "spring"  # Spring speeds up development by keeping your application
  # running in the background. Read more: https://github.com/rails/spring
  gem "spring-commands-rspec", require: false # allow spring to wrap the rspec command
  gem "bullet" # ActiveRecord N+1 detection
  gem "ffaker"
  gem "faker"
end

group :development do
  gem "thin"
  gem "rack-mini-profiler"
  gem "web-console", "~> 3.0" # Access an IRB console on exception pages or by using <%= console %> in views
  gem "foreman", require: false # for use with Procfile.development
  #  gem "mail_safe", "~> 0.3" # provides a safety net while developing an application that uses ActionMailer
  gem "awesome_print", require: false
end

group :test do
  gem "i18n-tasks", "~> 0.9.5"
  gem "capybara", "~> 2.6.2"
  gem "shoulda-matchers", "~> 3.1.1", require: false
  gem "rspec-activemodel-mocks", "~> 1.0"
  gem "poltergeist", "~> 1.9.0" # Needed for headless testing with Javascript or pages that ref external sites
  gem "launchy", require: false # save_and_open_page
  gem "database_cleaner", "~> 1.5.1"
  gem "fuubar" # Enhanced rspec progress formatter
  gem "rspec_junit_formatter" # For CircleCI metadata reports
  gem "simplecov", require: false # Tool for checking code coverage
  gem "email_spec"
end

group :production, :qa, :staging do
  gem "whenever" # for creating chron jobs
  gem "rails_12factor", "~> 0.0" # Useful if deploying to Heroku
  gem "airbrake", "~> 5.0" # Airbrake catches exceptions, sends them to https://dst-errbit.herokuapp.com
end
