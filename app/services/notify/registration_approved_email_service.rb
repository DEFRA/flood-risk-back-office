# frozen_string_literal: true

module Notify
  class RegistrationApprovedEmailService < FloodRiskEngine::Notify::BaseSendEmailService
    private

    def notify_options
      {
        email_address: @recipient_address,
        template_id:,
        personalisation: {
          registration_number: @enrollment.reference_number,
          exemption_description: enrollment_description,
          grid_reference:,
          assets: assets?,
          salmonid: salmonid?,
          decision_date:,
          organisation_name_and_address:,
          contact_name_and_position:,
          contact_phone: correspondence_contact.telephone_number,
          contact_email: correspondence_contact.email_address
        }
      }
    end

    def template_id
      "c814587b-1368-4f64-a9b9-da101f9a078b"
    end

    def enrollment_exemption
      @enrollment_exemption ||= @enrollment.enrollment_exemptions.first
    end

    def grid_reference
      @enrollment.exemption_location.grid_reference
    end

    def assets?
      enrollment_exemption.asset_found? ? "yes" : "no"
    end

    def salmonid?
      enrollment_exemption.salmonid_river_found? ? "yes" : "no"
    end

    def decision_date
      I18n.l(enrollment_exemption.accept_reject_decision_at, format: :long)
    end

    def organisation_name_and_address
      FormatOrganisationAddressService.run(
        organisation: @enrollment.organisation, line_separator: "\n"
      )
    end

    def correspondence_contact
      @correspondence_contact ||= @enrollment.correspondence_contact
    end

    def contact_name_and_position
      [correspondence_contact.full_name, correspondence_contact.position].compact.join(", ").to_s
    end
  end
end
