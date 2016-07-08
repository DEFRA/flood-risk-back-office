require "rails_helper"

RSpec.describe EnrollmentExemptionPresenter, type: :presenter do
  subject do
    described_class.new(enrollment_exemption, nil)
  end

  context "headers" do
    let(:enrollment) { create(:approved_partnership) }

    let(:enrollment_exemption) { enrollment.enrollment_exemptions.first }

    it "creates one row per partner" do
      data = subject.registration_and_operator_data

      expect(
        data.keys.size
      ).to eq PartnershipPresenter.registration_panel_max_row + enrollment.organisation.partners.size
    end
  end
end
