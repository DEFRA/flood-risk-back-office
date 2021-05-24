source "https://rubygems.org"
ruby "2.7.1"

gem "aws-sdk-resources"
gem "devise"
gem "devise_invitable"
gem "devise-security"
gem "govuk_admin_template"
gem "govuk_template"
gem "govuk_elements_rails"
gem 'govuk_frontend_toolkit', :git => "https://github.com/alphagov/govuk_frontend_toolkit_gem.git", :submodules => true
gem "kaminari"
gem "paper_trail"
gem "pg"
gem "pundit"
gem "rails", "~> 6.0"
gem "rolify"
gem "sass-rails"
gem "simple_form"

# replaces squeel (deprecated)
gem "baby_squeel", git: "https://github.com/vitalinfo/baby_squeel.git"
gem "ransack", require: false # because we need 'polyamorous' (see ransack initializer)

gem "record_tag_helper" # supports the deprecated `content_tag_for`
gem "uglifier"
gem "validates_timeliness"
gem "whenever"

gem "flood_risk_engine",
    git: "https://github.com/DEFRA/flood-risk-engine",
    branch: "chore/upgrade-to-rails-6"

gem "defra_ruby_aws"
gem "defra_ruby_email"
gem "github_changelog_generator", require: false

gem "dotenv-rails"

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
  gem "shoulda-matchers"
  gem "simplecov"#
end

group :production do
  # Use Passenger as our web-server/app-server (e.g. on AWS via Upstart, Heroku
  # via Procfile) # via Procfile)
  gem "passenger"#, "~> 5.0", ">= 5.0.30", require: "phusion_passenger/rack_handler"
end
