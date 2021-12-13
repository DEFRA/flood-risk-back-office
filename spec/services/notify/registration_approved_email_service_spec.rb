require "rails_helper"

module Notify
  RSpec.describe RegistrationApprovedEmailService do
    describe ".run" do
      let!(:template_id) { "c814587b-1368-4f64-a9b9-da101f9a078b" }
      let(:recipient_address) { Faker::Internet.safe_email }

      let!(:enrollment) do
        create(:approved_limited_company, reference_number: FloodRiskEngine::ReferenceNumber.create)
      end

      let(:exemption_description) do
        exemption = enrollment.exemptions.first
        "#{exemption.summary} #{exemption.code}."
      end

      let(:presenter) do
        ExemptionEmailPresenter.new(enrollment.enrollment_exemptions.first)
      end

      let(:expected_notify_options) do
        {
          email_address: recipient_address,
          template_id: template_id,
          personalisation: {
            registration_number: enrollment.reference_number,
            exemption_description: exemption_description,
            grid_reference: presenter.grid_reference,
            assets: "no",
            salmonid: "no",
            decision_date: presenter.decision_date,
            organisation_name_and_address: presenter.organisation_name_and_address,
            contact_name_and_position: presenter.contact_name_and_position,
            contact_phone: presenter.telephone_number,
            contact_email: presenter.email_address
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
            enrollment: enrollment,
            recipient_address: recipient_address
          )
        end
      end

      it "sends an email" do
        expect(subject).to be_a(Notifications::Client::ResponseNotification)
        expect(subject.template["id"]).to eq(template_id)
        expect(subject.content["subject"]).to eq("Flood risk activity exemption successfully registered")
      end
    end
  end
end
