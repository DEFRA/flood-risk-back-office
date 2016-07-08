require "rails_helper"
require "shoulda/matchers"

RSpec.describe PrepareEnrollmentExportReport, type: :service do
  let(:export) { build(:enrollment_export) }

  let(:enrollment) { create(:approved_individual) }
  let(:enrollment_exemption) { enrollment.enrollment_exemptions.first }

  let(:subject) { PrepareEnrollmentExportReport.new(export) }

  describe "#output csv data" do
    it "is the correct type" do
      expect(subject.csv_data).to be_a(Array)
    end
  end

  describe "#generation" do
    it "re-raises any caught exception when a row fails" do
      allow(enrollment_exemption).to receive(:status).and_raise(FloodRiskEngine::InvalidEnrollmentStateError)

      expect {
        subject.generate_row(enrollment_exemption).new(enrollment_exemption).call
      }.to raise_error(FloodRiskEngine::InvalidEnrollmentStateError)
    end
  end
end
