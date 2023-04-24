require "rails_helper"

module Notify
  RSpec.describe RegistrationApprovedEmailService do
    describe ".run" do
      let!(:enrollment) do
        create(:approved_limited_company, reference_number: FloodRiskEngine::ReferenceNumber.create)
      end

      let(:recipient_address) { Faker::Internet.email }

      let(:enrollment_exemption) do
        enrollment.enrollment_exemptions.first
      end

      let(:expected_exemption_description) do
        exemption = enrollment.exemptions.first
        "#{exemption.summary} #{exemption.code}"
      end

      let(:expected_decision_date) do
        I18n.l(
          enrollment_exemption.accept_reject_decision_at,
          format: :long
        )
      end

      let(:expected_organisation_name_and_address) do
        FormatOrganisationAddressService.run(
          organisation: enrollment.organisation,
          line_separator: "\n"
        )
      end

      let(:expected_contact_name_and_position) do
        correspondence_contact = enrollment.correspondence_contact
        [correspondence_contact.full_name, correspondence_contact.position].compact.join(", ").to_s
      end

      let(:expected_notify_options) do
        {
          email_address: recipient_address,
          template_id: "c814587b-1368-4f64-a9b9-da101f9a078b",
          personalisation: {
            registration_number: enrollment.reference_number,
            exemption_description: expected_exemption_description,
            grid_reference: enrollment.exemption_location.grid_reference,
            assets: "yes",
            salmonid: "yes",
            decision_date: expected_decision_date,
            organisation_name_and_address: expected_organisation_name_and_address,
            contact_name_and_position: expected_contact_name_and_position,
            contact_phone: enrollment.correspondence_contact.telephone_number,
            contact_email: enrollment.correspondence_contact.email_address
          }
        }
      end

      before do
        expect_any_instance_of(Notifications::Client)
          .to receive(:send_email)
          .with(expected_notify_options)
          .and_call_original
      end

      subject do
        VCR.use_cassette("registration_approved_sends_an_email") do
          described_class.run(
            enrollment:,
            recipient_address:
          )
        end
      end

      it "sends an email" do
        expect(subject).to be_a(Notifications::Client::ResponseNotification)
        expect(subject.template["id"]).to eq("c814587b-1368-4f64-a9b9-da101f9a078b")
        expect(subject.content["subject"]).to eq("Flood risk activity exemption successfully registered")
      end
    end
  end
end
