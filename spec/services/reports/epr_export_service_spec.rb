# frozen_string_literal: true

require "rails_helper"
require "defra_ruby/aws"

module Reports
  RSpec.describe EprExportService do
    describe ".run" do
      it "creates a csv file and load it to AWS" do
        epr_serializer = double(:epr_serializer)
        epr_report = double(:epr_report)
        result = double(:result, successful?: true, result: true)
        file = double(:file)
        bucket = double(:bucket)

        expect(epr_serializer).to receive(:to_csv).and_return(epr_report)
        expect(EprSerializer).to receive(:new).and_return(epr_serializer)

        expect(File).to receive(:write)

        expect(DefraRuby::Aws).to receive(:get_bucket).and_return(bucket)
        expect(File).to receive(:new).and_return(file)
        expect(bucket).to receive(:load).with(file, { s3_directory: "EPR" }).and_return(result)

        expect(File).to receive(:unlink)

        described_class.run
      end
    end

    context "if the load to AWS fails 3 times" do
      it "logs an error" do
        epr_serializer = double(:epr_serializer)
        epr_report = double(:epr_report)
        result = double(:result, successful?: false)
        file = double(:file)
        bucket = double(:bucket)

        expect(epr_serializer).to receive(:to_csv).and_return(epr_report)
        expect(EprSerializer).to receive(:new).and_return(epr_serializer)

        expect(File).to receive(:write)

        expect(DefraRuby::Aws).to receive(:get_bucket).and_return(bucket)
        expect(File).to receive(:new).and_return(file).exactly(3).times
        expect(bucket).to receive(:load).with(file, { s3_directory: "EPR" }).and_return(result).exactly(3).times

        expect(result).to receive(:error)
        expect(Airbrake).to receive(:notify)
        expect(Rails.logger).to receive(:error)
        expect(File).to receive(:unlink)

        described_class.run
      end
    end
  end
end
