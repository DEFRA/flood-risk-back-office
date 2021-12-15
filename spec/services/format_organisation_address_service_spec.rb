require "rails_helper"

RSpec.describe FormatOrganisationAddressService, type: :service do
  context ".run" do
    subject do
      described_class.run(organisation: organisation, separator: "\n")
    end

    context "limited_company" do
      let(:organisation) do
        create(:organisation, :as_limited_company, primary_address: address)
      end

      let(:address) do
        create(:address, :primary)
      end

      it "formats the organisation's name and address" do
        expect(subject).to eq(
          "#{organisation.name}\n"\
          "#{address.premises}, #{address.street_address}\n"\
          "#{address.locality}\n"\
          "#{address.city}\n"\
          "#{address.postcode}"
        )
      end
    end

    context "partnership" do
      let(:partner_one) do
        create(:partner_with_contact)
      end

      let(:partner_two) do
        create(:partner_with_contact)
      end

      let(:organisation) do
        create(:organisation, :as_partnership, partners: [partner_one, partner_two])
      end

      it "formats the partner's names and addresses" do
        expect(subject).to match(
          "#{partner_one.full_name}\n"\
          "#{partner_one.address.premises}, #{partner_one.address.street_address}\n"\
          "#{partner_one.address.locality}\n"\
          "#{partner_one.address.city}\n"\
          "#{partner_one.address.postcode}\n"\
          "#{partner_two.full_name}\n"\
          "#{partner_two.address.premises}, #{partner_two.address.street_address}\n"\
          "#{partner_two.address.locality}\n"\
          "#{partner_two.address.city}\n"\
          "#{partner_two.address.postcode}"
        )
      end
    end
  end
end
