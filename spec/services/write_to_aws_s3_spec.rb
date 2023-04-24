require "rails_helper"

RSpec.describe WriteToAwsS3, type: :service do
  describe ".run" do
    subject { described_class.run(enrollment_export) }

    let(:enrollment_export) { create(:enrollment_export, :with_dates, :with_file_name, :completed) }

    before do
      Aws.config.update({ region: "eu-west-1", credentials: Aws::Credentials.new("key_id", "access_key") })
      stub_request(:put, %r{https://.*\.s3\.eu-west-1\.amazonaws\.com.*})
    end

    it "returns a presigned url structure" do
      expect(described_class.run(enrollment_export)).to be true
    end
  end
end
