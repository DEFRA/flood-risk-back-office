require "rails_helper"

RSpec.describe ExemptionEmailPresenter, type: :presenter do
  context "Rejections" do
    let(:enrollment) { create(:rejected_individual) }

    let(:enrollment_exemption) { enrollment.enrollment_exemptions.first }

    subject do
      described_class.new(enrollment_exemption)
    end

    it { is_expected.to respond_to(:reference_number) }

    describe "#reference_number" do
      it do
        expect(subject.reference_number).to eq(enrollment.reference_number)
      end
    end
  end

  context "Approvals" do
    let(:enrollment) { create(:approved_individual) }

    let(:enrollment_exemption) { enrollment.enrollment_exemptions.first }

    subject do
      described_class.new(enrollment_exemption)
    end

    it { is_expected.to respond_to(:reference_number) }

    describe "#reference_number" do
      it do
        expect(subject.reference_number).to eq(enrollment.reference_number)
      end
    end
  end
end
