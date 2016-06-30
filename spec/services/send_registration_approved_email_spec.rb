require "rails_helper"

module FloodRiskEngine
  RSpec.describe SendRegistrationApprovedEmail, type: :service do
    let(:mailer) { RegistrationApprovedMailer }

    let(:enrollment) { create(:approved_individual) }
    let(:enrollment_exemption) { enrollment.enrollment_exemptions.first }

    describe "#call" do
      context "argument validation" do
        it "raises an error when a nil enrollment_exemption passed" do
          expect { described_class.new(nil).call }.to raise_error(ArgumentError)
        end

        it "raises an error if the enrollment_exemption is not approved?" do
          enrollment_exemption.building!
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

      context "primary_contact_email and 'other email recipient' (aka secondary contact) are different" do
        it "sends an email to each address", duff: true do
          expect(enrollment_exemption).to be_approved

          expect(enrollment.correspondence_contact.email_address).to be_present
          expect(enrollment.secondary_contact.email_address).to be_present

          service_object = described_class.new(enrollment_exemption)

          primary_contact_email   = enrollment.correspondence_contact.email_address
          secondary_contact_email = enrollment.secondary_contact.email_address

          expect(primary_contact_email).to_not eq(secondary_contact_email)

          message_delivery = instance_double(ActionMailer::MessageDelivery)
          expect(message_delivery).to receive(:deliver_later).exactly(:twice)

          expect(service_object.distinct_recipients.size).to eq 2

          expect(mailer).to receive(:approved)
            .exactly(:once)
            .with(enrollment_exemption: enrollment_exemption, recipient_address: primary_contact_email)
            .and_return(message_delivery)

          expect(mailer).to receive(:approved)
            .exactly(:once)
            .with(enrollment_exemption: enrollment_exemption, recipient_address: secondary_contact_email)
            .and_return(message_delivery)

          service_object.call
        end
      end

      context "when correspondence contact and secondary contact have the same email addresses" do
        let(:secondary_contact) do
          FactoryGirl.create(:contact, email_address: enrollment.correspondence_contact.email_address)
        end

        it "sends one email to the shared address" do
          enrollment.update(secondary_contact: secondary_contact)

          expect(enrollment_exemption).to be_approved

          primary_contact_email = enrollment.correspondence_contact.email_address

          expect(primary_contact_email).to_not be_blank
          expect(primary_contact_email).to eq(enrollment.secondary_contact.email_address)

          message_delivery = instance_double(ActionMailer::MessageDelivery)
          expect(message_delivery).to receive(:deliver_later).exactly(:once)

          service_object = described_class.new(enrollment_exemption)

          expect(mailer).to receive(:approved)
            .exactly(:once)
            .with(enrollment_exemption: enrollment_exemption, recipient_address: primary_contact_email)
            .and_return(message_delivery)

          expect(service_object.distinct_recipients.size).to eq 1
          service_object.call
        end
      end

      context "when seconday contact is nil since it is optional in the 'email other' form" do
        it "sends one email to the correspondence contact and does not use empty ('') secondary email" do
          enrollment.secondary_contact.update email_address: "" # should result in it not being sent
        end

        it "sends one email to the correspondence contact and does not use nil secondary email" do
          enrollment.secondary_contact.update email_address: nil # should result in it not being sent
        end

        after(:each) do
          expect(enrollment_exemption).to be_approved

          service_object = described_class.new(enrollment_exemption)

          expect(enrollment.correspondence_contact.email_address).to_not be_blank

          expect(service_object.distinct_recipients.size).to eq 1

          message_delivery = instance_double(ActionMailer::MessageDelivery)
          expect(message_delivery).to receive(:deliver_later).exactly(:once)

          expect(mailer).to receive(:approved)
            .exactly(:once)
            .with(
              enrollment_exemption: enrollment_exemption,
              recipient_address: enrollment.correspondence_contact.email_address
            ).and_return(message_delivery)

          service_object.call
        end
      end
    end
  end
end
