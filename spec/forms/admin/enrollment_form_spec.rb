require "rails_helper"
require "shoulda/matchers"

module Admin
  RSpec.describe EnrollmentForm, type: :form do
    let(:correspondence_contact) { FactoryGirl.create(:contact) }
    let(:secondary_contact) { FactoryGirl.create(:contact) }
    let(:organisation) do
      FactoryGirl.create :organisation
    end
    let(:enrollment) do
      FactoryGirl.create(
        :enrollment,
        submitted_at: Time.zone.now,
        correspondence_contact: correspondence_contact,
        secondary_contact: secondary_contact,
        organisation: organisation
      )
    end
    let(:enrollment_exemption) do
      FactoryGirl.create(
        :enrollment_exemption,
        status: FloodRiskEngine::EnrollmentExemption.statuses[:pending],
        enrollment: enrollment
      )
    end
    let(:form) { described_class.new(enrollment) }
    let(:organisation_name) { Faker::Company.name }
    let(:correspondence_contact_full_name) { Faker::Name.name }
    let(:correspondence_contact_position) { Faker::Company.profession }
    let(:correspondence_contact_telephone_number) { "0300 065 3000" }
    let(:correspondence_contact_email_address) { Faker::Internet.safe_email }
    let(:secondary_contact_email_address) { Faker::Internet.safe_email }
    let(:params) do
      {
        form.params_key => {
          organisation_name: organisation_name,
          correspondence_contact_full_name: correspondence_contact_full_name,
          correspondence_contact_position: correspondence_contact_position,
          correspondence_contact_telephone_number: correspondence_contact_telephone_number,
          correspondence_contact_email_address: correspondence_contact_email_address,
          secondary_contact_email_address: secondary_contact_email_address
        }
      }
    end

    describe ".validate" do
      it "should return true if params valid" do
        expect(form.validate(params)).to be(true)
      end

      it "should validate organisation_name presence" do
        expect(form).to validate_presence_of(:organisation_name)
          .with_message(described_class.t(".errors.organisation_name.blank"))
      end

      it "should validate correspondence_contact_full_name presence" do
        expect(form).to validate_presence_of(:correspondence_contact_full_name)
          .with_message(described_class.t(".errors.correspondence_contact_full_name.blank"))
      end

      it "should validate correspondence_contact_telephone_number presence" do
        expect(form).to validate_presence_of(:correspondence_contact_telephone_number)
          .with_message(described_class.t(".errors.correspondence_contact_telephone_number.blank"))
      end

      it "should validate correspondence_contact_email_address presence" do
        expect(form).to validate_presence_of(:correspondence_contact_email_address)
          .with_message(
            described_class.t(".errors.email_address.blank", contact: :correspondence)
          )
      end

      context "with partnership" do
        let(:organisation) { FactoryGirl.create(:organisation, :as_partnership) }
        let(:organisation_name) { nil }

        it "should not validate organisation_name presence" do
          expect(form.validate(params)).to be(true)
        end
      end
    end

    describe ".save" do
      before { form.validate(params) }

      it "should return true" do
        expect(form.save).to be_truthy
      end

      it "should save data to objects" do
        form.save
        organisation.reload
        correspondence_contact.reload
        secondary_contact.reload

        expect(organisation.name).to eq(organisation_name)
        expect(correspondence_contact.full_name).to eq(correspondence_contact_full_name)
        expect(correspondence_contact.telephone_number).to eq(correspondence_contact_telephone_number)
        expect(correspondence_contact.email_address).to eq(correspondence_contact_email_address)
        expect(secondary_contact.email_address).to eq(secondary_contact_email_address)
      end
    end

    describe ".edit_name?" do
      it "should normally return true" do
        expect(form.edit_name?).to be_truthy
      end

      context "with partnership" do
        let(:organisation) { FactoryGirl.create(:organisation, :as_partnership) }

        it "should not validate organisation_name presence" do
          expect(form.edit_name?).to be_falsey
        end
      end
    end
  end
end
