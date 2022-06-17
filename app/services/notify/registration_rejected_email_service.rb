# frozen_string_literal: true

module Notify
  class RegistrationRejectedEmailService < FloodRiskEngine::Notify::BaseSendEmailService
    private

    def notify_options
      {
        email_address: @recipient_address,
        template_id:,
        personalisation: {
          registration_number: @enrollment.reference_number
        }
      }
    end

    def template_id
      "bbe3ae28-f34e-4215-9f56-a23827aa02c3"
    end
  end
end
