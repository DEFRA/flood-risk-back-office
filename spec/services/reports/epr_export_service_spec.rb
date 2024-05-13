# frozen_string_literal: true

require "rails_helper"
require "defra_ruby/aws"

module Reports
  RSpec.describe EprExportService do
    let(:enrollment_exemption) { build(:enrollment_exemption) }
    let(:bucket) { double(:bucket) }

    before do
      allow(FloodRiskEngine::EnrollmentExemption).to receive(:approved).and_return([enrollment_exemption])
      allow(DefraRuby::Aws).to receive(:get_bucket).and_return(bucket)
      allow(bucket).to receive(:load).with(anything, { s3_directory: "EPR" }).and_return(result)
    end

    describe ".run" do
      let(:result) { double(:result, successful?: true, result: true) }

      it "creates a csv file and loads it to AWS" do
        expect(bucket).to receive(:load).with(anything, { s3_directory: "EPR" }).and_return(result)
        expect(File).to receive(:unlink)

        described_class.run
      end
    end

    context "if the load to AWS fails 3 times" do
      let(:result) { double(:result, successful?: false) }

      it "logs an error" do
        expect(bucket).to receive(:load).with(anything, { s3_directory: "EPR" }).and_return(result).exactly(3).times
        expect(result).to receive(:error)
        expect(Airbrake).to receive(:notify)
        expect(Rails.logger).to receive(:error)
        expect(File).to receive(:unlink)

        described_class.run
      end
    end
  end
end
