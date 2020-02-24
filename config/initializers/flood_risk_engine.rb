# frozen_string_literal: true

FloodRiskEngine.configure do |config|
  # By default we use a different layout to the host app (ie we don't use application by default)
  # because that layout may include calls to helper methods that we (as an isolated engine)
  # don't have access to.
  config.layout = "flood_risk_engine"
  config.require_journey_completed_in_same_browser = false

  # Last email cache config
  # NOTE This will enable `/fre/email/last-email`. However we want to be
  # consistent with the front office and our other services and access this at
  # `/email/last-email`. The only way to do this was to mount the engine
  # directly in the back-office. So we have this here more as a note to 'go
  # look over there' for the actual implementation, and because it makes sense
  # to have both routes working the same, even if we'll only really ever hit
  # the `/email/last-email` version.
  config.use_last_email_cache = ENV["USE_LAST_EMAIL_CACHE"] || false

  # Configure airbrake, which is done via the engine use defra_ruby_alert
  config.airbrake_enabled = ENV["USE_AIRBRAKE"]
  config.airbrake_host = Rails.application.secrets.airbrake_host
  config.airbrake_project_key = Rails.application.secrets.airbrake_project_key
  config.airbrake_blacklist = [
    # Catch-all "safety net" regexes.
    /password/i,
    /postcode/i,

    :full_name,

    :name,
    :telephone_number,

    :email,
    :email_address,
    :email_address_confirmation,

    :reset_password_token,
    :confirmation_token,
    :unconfirmed_email,
    :unlock_token,

    :comment,

    # Other things we'll filter beacuse we're super-diligent.
    :_csrf_token,
    :session_id,
    :authenticity_token
  ]
end
FloodRiskEngine.start_airbrake
