require "rails_helper"
require "sucker_punch/testing/inline"

RSpec.describe EnrollmentExportJob do
  subject(:job) { described_class.perform_now(export) }

  describe ".perform_later" do
    # let(:enrollment) { create(:enrollment, submitted_at: Date.today) }
    let(:enrollment) { create(:approved_individual) }
    # let!(:exemption) { create(:enrollment_exemption, enrollment: enrollment, accept_reject_decision_at: Date.today) }
    let!(:exemption) { enrollment.enrollment_exemptions.first }
    let(:export) { create(:enrollment_export, :with_dates, :with_file_name) }

    it "does not error" do
      expect { job }.not_to raise_error
    end
  end
end
