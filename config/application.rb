require File.expand_path("../boot", __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
require_relative "../lib/core_ext/action_view/helpers/url_helper"

# See comment 'Add custom delivery method for emails' below
require_relative "../app/lib/notify_mail"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FloodRiskBackOffice
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.to_prepare do
      Rails.root.glob("app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end

    config.autoload_paths << Rails.root.join("app/presenters/concerns")
    config.autoload_paths << Rails.root.join("app/forms/admin/enrollment_exemptions/concerns")

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "London"

    # Minutes the EA area lookup job should run for
    config.area_lookup_run_for = ENV["AREA_LOOKUP_RUN_FOR"] || 60

    # Data export config
    config.epr_reports_bucket_name = ENV.fetch("FRA_AWS_DAILY_EXPORT_BUCKET")
    config.epr_export_filename = ENV["EPR_DAILY_REPORT_FILE_NAME"] || "flood_risk_epr_daily_full"

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.{rb,yml}").to_s]
    # config.i18n.default_locale = :de

    # Fix sass compilation error in govuk_frontend:
    # SassC::SyntaxError: Error: "calc(0px)" is not a number for `max'
    # https://github.com/alphagov/govuk-frontend/issues/1350
    config.assets.css_compressor = nil

    # Database cleanup
    config.max_transient_registration_age_days = ENV["MAX_TRANSIENT_REGISTRATION_AGE_DAYS"] || 30

    # Allow deserialization of Time objects:
    config.active_record.yaml_column_permitted_classes = [Time]

    # Add custom delivery method for emails
    ActionMailer::Base.add_delivery_method(:notify_mail, NotifyMail)
  end
end
