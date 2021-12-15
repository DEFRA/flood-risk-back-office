require "rails_helper"

module FloodRiskEngine
  RSpec.describe SendRegistrationRejectedEmail, type: :service do
    let(:email_service) { ::Notify::RegistrationRejectedEmailService }

    let(:enrollment) { create(:rejected_individual) }
    let(:enrollment_exemption) { enrollment.enrollment_exemptions.first }

    describe "#call" do
      context "argument validation" do
        it "raises an error when a nil enrollment passed" do
          expect { described_class.new(nil).call }.to raise_error(ArgumentError)
        end

        it "raises an error if the enrollment is not rejected?" do
          enrollment_exemption.building!
          enrollment.reload
          expect(enrollment_exemption.building?).to be true

          expect {
            described_class.new(enrollment_exemption).call
          }.to raise_error(FloodRiskEngine::InvalidEnrollmentStateError)
        end

        it "raises an error if there is no correspondence contact email address" do
          enrollment.correspondence_contact.update email_address: nil
          expect {
            described_class.new(enrollment_exemption).call
          }.to raise_error(FloodRiskEngine::MissingEmailAddressError)
        end
      end

      context "primary_contact_email and  secondary contact are different" do
        it "sends an email to each address" do
          expect(enrollment_exemption).to be_rejected

          primary_contact_email   = enrollment.correspondence_contact.email_address
          secondary_contact_email = enrollment.secondary_contact.email_address

          expect(primary_contact_email).to be_present
          expect(secondary_contact_email).to be_present
          expect(primary_contact_email).to_not eq(secondary_contact_email)

          expect(email_service).to receive(:run)
            .with(
              enrollment: enrollment,
              recipient_address: enrollment.correspondence_contact.email_address
            ).exactly(:once)

          expect(email_service).to receive(:run)
            .with(
              enrollment: enrollment,
              recipient_address: enrollment.secondary_contact.email_address
            ).exactly(:once)

          service_object = described_class.new(enrollment_exemption)

          expect(service_object.distinct_recipients.size).to eq 2

          service_object.call
        end
      end

      context "when correspondence and secondary contacts have same email addresses" do
        let(:secondary_contact) do
          FactoryBot.create(:contact, email_address: enrollment.correspondence_contact.email_address)
        end

        it "sends one email to the shared address" do
          expect(enrollment_exemption).to be_rejected

          expect(enrollment.correspondence_contact.email_address).to_not be_blank
          enrollment.update secondary_contact: secondary_contact

          service_object = described_class.new(enrollment_exemption)

          expect(email_service).to receive(:run)
            .with(
              enrollment: enrollment,
              recipient_address: enrollment.correspondence_contact.email_address
            ).exactly(:once)

          expect(service_object.distinct_recipients.size).to eq 1
          service_object.call
        end
      end

      context "when seconday contact is nil" do
        it "sends one email to the correspondence contact when secondary email blank" do
          enrollment.secondary_contact.update email_address: ""
        end

        it "sends one email to the correspondence contact when secondary email nil" do
          enrollment.secondary_contact.update email_address: nil
        end

        after(:each) do
          expect(enrollment_exemption).to be_rejected

          service_object = described_class.new(enrollment_exemption)

          expect(service_object.distinct_recipients.size).to eq 1

          expect(email_service).to receive(:run)
            .with(
              enrollment: enrollment,
              recipient_address: enrollment.correspondence_contact.email_address
            ).exactly(:once)

          service_object.call
        end
      end
    end

    describe ".for" do
      it "sends an email to each address" do
        expect(email_service)
          .to receive(:run)
          .exactly(:twice)

        described_class.for enrollment_exemption
      end
    end
  end
end
