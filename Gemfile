source 'https://rubygems.org'
ruby '2.2.3'

gem 'rails', '4.2.6'
gem 'sass-rails', '~> 5.0.4'    # Use SCSS for stylesheets
gem 'uglifier', '>= 1.3.0'      # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '~> 4.1.0'  # Use CoffeeScript for .coffee assets and views
gem 'jquery-rails', '>= 3.1.4'  # Use jquery as the JavaScript library
gem 'turbolinks', '~> 2.5.3'    # Turbolinks makes following links in your web application faster.
# Read more: https://github.com/rails/turbolinks
gem "govuk_admin_template", "~> 4.1.0"
gem "govuk_frontend_toolkit", "~> 4.9.1" # Added this to get Tabs for Choosing Exemption working

gem "simple_form", "~> 3.2.0"
gem "pundit", "~> 1.1.0"
gem "devise", "~> 3.5.6"
gem "devise_invitable", "~> 1.5.3"
gem "sucker_punch", "~> 2.0.1"
gem 'aws-sdk-resources', '~> 2.2.27' # Amazon S3 API access (e.g. data exports)

gem 'digital_services_core', '1.0.0', tag: 'v1.0.0',
    git: 'https://github.com/EnvironmentAgency/digital-services-core'


# Automatically loads environment variables from .env into ENV. Specified here
# rather than in the group in case any of the gems we add depend on env
# variables being available.
gem 'dotenv-rails', groups: [:development, :test]

gem 'pg', '~> 0.18.4'           # Use Postgres for the DB
gem 'paper_trail', '~> 4.1.0'
gem 'quiet_assets', '~> 1.1.0'  # Mutes assets pipeline log messages
gem 'textacular', '~> 3.2.2'    # Postgres free-text search utilities
gem 'scenic', '~> 1.2.0'      # Versioned database views for Rails
gem 'virtus', '~> 1.0.5'      # Virtus allows you to define attributes on classes, modules or class
# instances with optional information about types - used in Presenters
gem 'validates_timeliness', '~> 4.0.2' # date/time validator for Rails and ActiveModel

# Use Passenger as our web-server/app-server
# (e.g. on AWS via Upstart, Heroku vi Procfile, and locally via Procfile.development
gem 'passenger', '~> 5.0.25', require: false

group :development, :test do
  gem 'factory_girl_rails', '~> 4.6.0', require: false # also enables "build_dummy_data" functionality in dev
  gem 'byebug'  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'rspec-rails', '~> 3.4.2'
  gem 'spring'  # Spring speeds up development by keeping your application
  # running in the background. Read more: https://github.com/rails/spring
  gem 'spring-commands-rspec', require: false # allow spring to wrap the rspec command
  gem 'bullet' # ActiveRecord N+1 detection
end

group :development do
  gem 'thin' # in Development, use the Thin web-server instead of Webrick, when calling "rails server"
  gem 'web-console', '~> 3.0' # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'foreman', require: false # for use with Procfile.development
  gem 'mail_safe', '~> 0.3' # provides a safety net while developing an application that uses ActionMailer
end

group :test do
  gem 'i18n-tasks', '~> 0.9.5'
  gem 'capybara', '~> 2.6.2'
  gem 'shoulda-matchers', '~> 3.1.1', require: false
  gem 'rspec-activemodel-mocks', '~> 1.0'
  gem 'poltergeist', '~> 1.9.0' # Needed for headless testing with Javascript or pages that ref external sites
  gem 'launchy', require: false # save_and_open_page
  gem 'database_cleaner', '~> 1.5.1'
  gem 'fuubar' # Enhanced rspec progress formatter
  gem 'rspec_junit_formatter' # For CircleCI metadata reports
  gem 'simplecov', require: false # Tool for checking code coverage
end

group :production, :qa, :staging do
  gem 'rails_12factor', '~> 0.0' # Useful if deploying to Heroku
  gem 'airbrake', '~> 5.0' # Airbrake catches exceptions, sends them to https://dst-errbit.herokuapp.com
end
