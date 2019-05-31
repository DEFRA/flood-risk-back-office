require "rails_helper"
require "shoulda/matchers"
module Enrollments
  RSpec.describe PartnerForm, type: :form do
    let(:partner) { FactoryBot.create(:partner_with_contact) }
    let(:contact) { partner.contact }
    let(:address) { contact.address }
    let(:enrollment) { FactoryBot.create(:enrollment) }

    let(:form) { described_class.new(enrollment, partner) }

    it "should validate organisation_name" do
      expect(form).to validate_length_of(:premises)
    end

    describe ".save" do
      let(:full_name) { Faker::Name.name }
      let(:city) { Faker::Address.city }
      let(:params) do
        {
          address: address.attributes.merge(
            "city" => city,
            "full_name" => full_name
          )
        }
      end
      before do
        form.validate(params)
        form.save
      end

      it "should save full_name to contact" do
        expect(contact.reload.full_name).to eq(full_name)
      end

      it "should save city to address" do
        expect(address.reload.city).to eq(city)
      end
    end
  end
end
