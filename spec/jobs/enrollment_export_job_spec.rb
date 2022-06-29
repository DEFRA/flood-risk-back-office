require "rails_helper"
require "sucker_punch/testing/inline"

RSpec.describe EnrollmentExportJob do
  subject(:job) { described_class.perform_now(ee) }

  describe ".perform_later" do
    let(:ee) { create(:enrollment_export, :with_dates, :with_file_name) }

    it "does not error" do
      job
    end
  end
end
