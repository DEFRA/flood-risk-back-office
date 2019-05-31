require "rails_helper"

module FloodRiskEngine
  RSpec.describe SendRegistrationRejectedEmail, type: :service do
    let(:mailer) { RegistrationRejectedMailer }

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

          message_delivery = instance_double(ActionMailer::MessageDelivery)
          expect(message_delivery).to receive(:deliver_later).exactly(:twice)

          expect(mailer).to receive(:rejected)
            .exactly(:once)
            .with(
              enrollment_exemption: enrollment_exemption,
              recipient_address: enrollment.correspondence_contact.email_address
            )
            .and_return(message_delivery)

          expect(mailer).to receive(:rejected)
            .exactly(:once)
            .with(
              enrollment_exemption: enrollment_exemption,
              recipient_address: enrollment.secondary_contact.email_address
            )
            .and_return(message_delivery)

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

          message_delivery = instance_double(ActionMailer::MessageDelivery)
          expect(message_delivery).to receive(:deliver_later).exactly(:once)

          service_object = described_class.new(enrollment_exemption)

          expect(mailer).to receive(:rejected)
            .exactly(:once)
            .with(
              enrollment_exemption: enrollment_exemption,
              recipient_address: enrollment.correspondence_contact.email_address
            )
            .and_return(message_delivery)

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

          message_delivery = instance_double(ActionMailer::MessageDelivery)
          expect(message_delivery).to receive(:deliver_later).exactly(:once)

          expect(mailer).to receive(:rejected)
            .exactly(:once)
            .with(
              enrollment_exemption: enrollment_exemption,
              recipient_address: enrollment.correspondence_contact.email_address
            )
            .and_return(message_delivery)

          service_object.call
        end
      end
    end

    describe ".for" do
      it "sends an email to each address" do
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        expect(message_delivery).to receive(:deliver_later).exactly(:twice)

        expect(mailer).to receive(:rejected)
          .exactly(:once)
          .with(
            enrollment_exemption: enrollment_exemption,
            recipient_address: enrollment.correspondence_contact.email_address
          )
          .and_return(message_delivery)

        expect(mailer).to receive(:rejected)
          .exactly(:once)
          .with(
            enrollment_exemption: enrollment_exemption,
            recipient_address: enrollment.secondary_contact.email_address
          )
          .and_return(message_delivery)

        described_class.for enrollment_exemption
      end
    end
  end
end
