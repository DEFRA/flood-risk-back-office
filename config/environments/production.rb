Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like
  # NGINX, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.serve_static_files = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # Compress JavaScripts and CSS.
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = false

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  #
  # Note that this is required for us to generate secure cookies. If the cookies are not secure
  # then they can be transported over a non-SSL connection as clear text, making them vulnerable.
  # However in production, a prequisite of this working is that Rails *knows* that the originating
  # request was over HTTPS. This is not as obvious as it should be because internal traffic from
  # the load balancer is always HTTP (the incoming SSL connection being terminated at the ELB).
  # To tell Rails about the original protocol, the X-Forwarded-Proto header must be set by nginx
  # or the ELB. If X-Forwarded-Proto=https then Rails is happy and will serve secure connections.
  # Without that header, an infinte loop will result if config.force_ssl=true, as Rails will always
  # think the protocol is http and will try and redirect every request to an https equivalent.
  config.force_ssl = true

  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :info

  # Prepend all log lines with the following tags.
  config.log_tags = [ :uuid ]

  # Use a different logger for distributed setups.
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  protocol = "https"
  host = ENV["DEFAULT_URL_HOST"] || fail("Environment variable DEFAULT_URL_HOST has not been set")

  Rails.application.routes.default_url_options =
    config.action_controller.default_url_options =
      config.action_mailer.default_url_options = { protocol: protocol, host: host }

  config.action_mailer.asset_host = "#{protocol}://#{host}"

  # action_mailer configuration settings
  config.action_mailer.delivery_method = :smtp

  # These are the minimum settings. On AWS we send email to postfix on the proxy server
  # so these 2 settings are all that is required.
  smtp = {
    address: (ENV["EMAIL_HOST"] || fail("Environment variable DEFAULT_URL_HOST has not been set")),
    port: (ENV["EMAIL_PORT"] || fail("Environment variable DEFAULT_URL_HOST has not been set"))
  }

  # This applies if using sendgrid
  if ENV["EMAIL_USERNAME"].present?
    smtp[:user_name] = ENV["EMAIL_USERNAME"]
    smtp[:authentication] = :plain
    smtp[:password] = ENV["EMAIL_PASSWORD"]
  end

  # E.g. Heroku
  if ENV["EMAIL_HOST"] == "smtp.sendgrid.net"
    smtp[:enable_starttls_auto] = true
    smtp[:ssl] = true
  end

  smtp[:domain] = ENV["EMAIL_APP_DOMAIN"] if ENV["EMAIL_APP_DOMAIN"].present?

  config.action_mailer.smtp_settings = smtp
end
