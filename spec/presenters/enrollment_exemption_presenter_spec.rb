require "rails_helper"

RSpec.describe EnrollmentExemptionPresenter, type: :presenter do
  let(:enrollment) { create(:approved_partnership) }
  let(:enrollment_exemption) { enrollment.enrollment_exemptions.first }

  let(:presenter) do
    template = double("template")
    allow(template).to receive(:link_to).and_return("")
    described_class.new(enrollment_exemption, template)
  end

  describe "#registration_and_operator_data" do
    it "creates one row per partner" do
      data = presenter.registration_and_operator_data

      expect(
        data.keys.size
      ).to eq PartnershipPresenter.registration_panel_max_row + enrollment.organisation.partners.size
    end
  end

  describe "#status_tag" do
    it "calls the status_label" do
      expect(presenter).to receive(:status_label).once

      presenter.status_tag
    end
  end

  describe "#blank_value" do
    it { expect(presenter.blank_value).to match(/Not specified/) }
  end
end
