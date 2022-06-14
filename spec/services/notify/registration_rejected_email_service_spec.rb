require "rails_helper"

module Notify
  RSpec.describe RegistrationRejectedEmailService do
    describe ".run" do
      let!(:template_id) { "bbe3ae28-f34e-4215-9f56-a23827aa02c3" }
      let(:recipient_address) { Faker::Internet.safe_email }

      let!(:enrollment) do
        create(:approved_limited_company, reference_number: FloodRiskEngine::ReferenceNumber.create)
      end

      let(:expected_notify_options) do
        {
          email_address: recipient_address,
          template_id:,
          personalisation: {
            registration_number: enrollment.reference_number
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
        VCR.use_cassette("registration_rejected_sends_an_email") do
          described_class.run(
            enrollment:,
            recipient_address:
          )
        end
      end

      it "sends an email" do
        expect(subject).to be_a(Notifications::Client::ResponseNotification)
        expect(subject.template["id"]).to eq(template_id)
        expect(subject.content["subject"]).to eq("Flood risk activity exemption – not registered")
      end
    end
  end
end
