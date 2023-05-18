# frozen_string_literal: true

require "notifications/client"

class NotifyMail
  attr_accessor :settings

  def initialize(settings)
    @settings = settings
  end

  def deliver!(mail)
    response = client.send_email(
      email_address: mail[:to].to_s,
      template_id: mail[:template_id].to_s,
      personalisation: mail_field_to_hash(mail[:personalisation])
    )

    mail[:response] = response.to_json
    Rails.logger.info(response.to_json)

    response
  rescue StandardError => e
    Rails.logger.error(e)
    throw e
  end

  private

  def client
    @_client ||= Notifications::Client.new(@settings[:api_key])
  end

  def mail_field_to_hash(field)
    parsed_field = JSON.parse(field.to_json)
    parsed_field["unparsed_value"].symbolize_keys
  end
end
