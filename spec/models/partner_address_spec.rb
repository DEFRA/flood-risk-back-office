require "rails_helper"

RSpec.describe PartnerAddress do
  context "validations" do
    it { should validate_presence_of(:full_name) }
  end

  describe "#full_name" do
    let!(:enrollment) { create(:submitted_partnership) }
    let(:token) { enrollment.partners.first.contact.address.token }

    let(:partner_address) { described_class.find_by(token:) }

    it "assigns the contacts'full_name" do
      expect(partner_address.full_name).to eq(enrollment.partners.first.contact.full_name)
    end

    it "updates the contact's full_name" do
      partner_address.update(full_name: "Alice Apples")

      expect(PartnerAddress.find_by(token:).full_name).to eq("Alice Apples")
    end
  end

  context "when the class is used incorrectly and there is no contact address" do
    let!(:enrollment) { create(:submitted_other) }

    it "does not assign a full_name" do
      expect(PartnerAddress.last.full_name).to be_nil
    end
  end
end
