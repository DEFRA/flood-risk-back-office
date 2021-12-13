# frozen_string_literal: true

module Notify
  class RegistrationApprovedEmailService < FloodRiskEngine::Notify::BaseSendEmailService
    private

    def notify_options
      {
        email_address: @recipient_address,
        template_id: template_id,
        personalisation: {
          registration_number: @enrollment.reference_number,
          exemption_description: enrollment_description,
          grid_reference: presenter.grid_reference,
          assets: presenter.asset?,
          salmonid: presenter.salmonid?,
          decision_date: presenter.decision_date,
          organisation_name_and_address: presenter.organisation_name_and_address,
          contact_name_and_position: presenter.contact_name_and_position,
          contact_phone: presenter.telephone_number,
          contact_email: presenter.email_address
        }
      }
    end

    def template_id
      "c814587b-1368-4f64-a9b9-da101f9a078b"
    end

    def presenter
      @presenter ||=
        ExemptionEmailPresenter.new(@enrollment.enrollment_exemptions.first)
    end
  end
end
