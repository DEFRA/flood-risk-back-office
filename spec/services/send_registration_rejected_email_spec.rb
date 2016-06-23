require "rails_helper"

module FloodRiskEngine
  RSpec.describe SendRegistrationRejectedEmail, type: :service do
    let(:mailer) { RegistrationRejectedMailer }

    let(:enrollment) { create(:rejected_individual) }

    describe "#call" do
      context "argument validation" do
        it "raises an error when a nil enrollment passed" do
          expect { described_class.new(nil).call }.to raise_error(ArgumentError)
        end

        it "raises an error if the enrollment is not rejected?" do
          enrollment.building!
          expect(enrollment.building?).to be true

          expect { described_class.new(enrollment).call }.to raise_error(FloodRiskEngine::InvalidEnrollmentStateError)
        end

        it "raises an error if there is no correspondence contact email address" do
          enrollment.correspondence_contact.email_address = ""
          expect { described_class.new(enrollment).call }.to raise_error(FloodRiskEngine::MissingEmailAddressError)
        end
      end

      context "primary_contact_email and 'other email recipient' (aka secondary contact) are different" do
        it "sends an email to each address" do
          expect(enrollment).to be_rejected

          primary_contact_email   = enrollment.correspondence_contact.email_address
          secondary_contact_email = enrollment.secondary_contact.email_address

          expect(enrollment).to be_rejected

          expect(primary_contact_email).to be_present
          expect(secondary_contact_email).to be_present
          expect(primary_contact_email).to_not eq(secondary_contact_email)

          message_delivery = instance_double(ActionMailer::MessageDelivery)
          expect(message_delivery).to receive(:deliver_later).exactly(:twice)

          expect(mailer).to receive(:rejected)
            .exactly(:once)
            .with(enrollment_id: enrollment.id, recipient_address: primary_contact_email)
            .and_return(message_delivery)

          expect(mailer).to receive(:rejected)
            .exactly(:once)
            .with(enrollment_id: enrollment.id, recipient_address: secondary_contact_email)
            .and_return(message_delivery)

          service_object = described_class.new(enrollment)

          expect(service_object.distinct_recipients.size).to eq 2
          service_object.call
        end
      end

      context "when correspondence contact and secondary contact have the same email addresses" do
        it "sends one email to the shared address" do
          enrollment.secondary_contact.email_address = enrollment.correspondence_contact.email_address

          expect(enrollment).to be_rejected

          primary_contact_email   = enrollment.correspondence_contact.email_address
          secondary_contact_email = enrollment.secondary_contact.email_address

          expect(primary_contact_email).to_not be_blank
          expect(primary_contact_email).to eq(secondary_contact_email)

          message_delivery = instance_double(ActionMailer::MessageDelivery)
          expect(message_delivery).to receive(:deliver_later).exactly(:once)

          service_object = described_class.new(enrollment)

          expect(mailer).to receive(:rejected)
            .exactly(:once)
            .with(enrollment_id: enrollment.id, recipient_address: primary_contact_email)
            .and_return(message_delivery)

          expect(service_object.distinct_recipients.size).to eq 1
          service_object.call
        end
      end

      context "when seconday contact is nil since it is optional in the 'email other' form" do
        it "sends one email to the correspondence contact and does not use empty ('') secondary email" do
          enrollment.secondary_contact.update email_address: "" # should result in it not being sent
        end

        it "sends one email to the correspondence contact and does not use nil) secondary email" do
          enrollment.secondary_contact = nil
          enrollment.save
        end

        after(:each) do
          expect(enrollment).to be_rejected

          service_object = described_class.new(enrollment)

          primary_contact_email = enrollment.correspondence_contact.email_address
          expect(primary_contact_email).to_not be_blank

          expect(service_object.distinct_recipients.size).to eq 1

          message_delivery = instance_double(ActionMailer::MessageDelivery)
          expect(message_delivery).to receive(:deliver_later).exactly(:once)

          expect(mailer).to receive(:rejected)
            .exactly(:once)
            .with(enrollment_id: enrollment.id, recipient_address: primary_contact_email)
            .and_return(message_delivery)

          service_object.call
        end
      end
    end
  end
end
