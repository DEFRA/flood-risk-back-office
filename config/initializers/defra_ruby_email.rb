# frozen_string_literal: true

DefraRubyEmail.configure do |configuration|
  configuration.notify_api_key = ENV.fetch("NOTIFY_API_KEY")

  # Enable the routes mounted in this app if the environment is configured for it
  configuration.enable = ENV["USE_LAST_EMAIL_CACHE"] || false
end
