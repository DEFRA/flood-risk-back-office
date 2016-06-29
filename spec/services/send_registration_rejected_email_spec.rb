require "rails_helper"

module FloodRiskEngine
  RSpec.describe SendRegistrationRejectedEmail, type: :service do
    let(:mailer) { RegistrationRejectedMailer }
    let(:correspondence_contact) { FactoryGirl.create(:contact) }
    let(:secondary_contact) { FactoryGirl.create(:contact) }
    let(:enrollment) do
      FactoryGirl.create(
        :enrollment,
        correspondence_contact: correspondence_contact,
        secondary_contact: secondary_contact
      )
    end
    let(:enrollment_exemption) do
      FactoryGirl.create(
        :enrollment_exemption,
        status: FloodRiskEngine::EnrollmentExemption.statuses[:rejected],
        enrollment: enrollment
      )
    end

    describe "#call" do
      context "argument validation" do
        it "raises an error when a nil enrollment passed" do
          expect { described_class.new(nil).call }.to raise_error(ArgumentError)
        end

        it "raises an error if the enrollment is not rejected?" do
          enrollment_exemption.building!
          enrollment.reload
          expect { described_class.new(enrollment_exemption).call }.to raise_error(FloodRiskEngine::InvalidEnrollmentStateError)
        end

        it "raises an error if there is no correspondence contact email address" do
          enrollment.correspondence_contact.email_address = ""
          enrollment.correspondence_contact.save
          expect { described_class.new(enrollment_exemption).call }.to raise_error(FloodRiskEngine::MissingEmailAddressError)
        end
      end

      context "primary_contact_email and 'other email recipient' (aka secondary contact) are different" do
        it "sends an email to each address" do

          message_delivery = instance_double(ActionMailer::MessageDelivery)
          expect(message_delivery).to receive(:deliver_later).exactly(:twice)

          expect(mailer).to receive(:rejected)
            .exactly(:once)
            .with(enrollment_exemption: enrollment_exemption, recipient_address: correspondence_contact.email_address)
            .and_return(message_delivery)

          expect(mailer).to receive(:rejected)
            .exactly(:once)
            .with(enrollment_exemption: enrollment_exemption, recipient_address: secondary_contact.email_address)
            .and_return(message_delivery)

          service_object = described_class.new(enrollment_exemption)

          expect(service_object.distinct_recipients.size).to eq 2
          service_object.call
        end
      end

      context "when correspondence contact and secondary contact have the same email addresses" do
        let(:secondary_contact) do
          FactoryGirl.create(
            :contact,
            email_address: correspondence_contact.email_address
          )
        end

        it "sends one email to the shared address" do

          message_delivery = instance_double(ActionMailer::MessageDelivery)
          expect(message_delivery).to receive(:deliver_later).exactly(:once)

          service_object = described_class.new(enrollment_exemption)

          expect(mailer).to receive(:rejected)
            .exactly(:once)
            .with(enrollment_exemption: enrollment_exemption, recipient_address: correspondence_contact.email_address)
            .and_return(message_delivery)

          expect(service_object.distinct_recipients.size).to eq 1
          service_object.call
        end
      end

      context "when seconday contact is nil since it is optional in the 'email other' form" do

        let(:secondary_contact) do
          FactoryGirl.create(
            :contact,
            email_address: @email_address
          )
        end

        it "sends one email to the correspondence contact and does not use empty ('') secondary email" do
          @email_address = ""
        end

        it "sends one email to the correspondence contact and does not use nil) secondary email" do
          @email_address = nil
        end

        after(:each) do
          expect(enrollment_exemption).to be_rejected

          service_object = described_class.new(enrollment_exemption)
          primary_contact_email = correspondence_contact.email_address

          expect(service_object.distinct_recipients.size).to eq 1

          message_delivery = instance_double(ActionMailer::MessageDelivery)
          expect(message_delivery).to receive(:deliver_later).exactly(:once)

          expect(mailer).to receive(:rejected)
            .exactly(:once)
            .with(enrollment_exemption: enrollment_exemption, recipient_address: primary_contact_email)
            .and_return(message_delivery)

          service_object.call
        end
      end
    end
  end
end
