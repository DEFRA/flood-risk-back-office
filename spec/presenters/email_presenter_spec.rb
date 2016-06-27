require "rails_helper"

RSpec.describe EmailPresenter, type: :presenter do
  context "Rejections" do
    let(:enrollment) { create(:rejected_individual) }

    subject do
      described_class.new(enrollment)
    end

    it { is_expected.to respond_to(:reference_number) }

    describe "#reference_number" do
      it do
        expect(subject.reference_number).to eq(enrollment.reference_number)
      end
    end
  end
end
