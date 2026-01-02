require "rails_helper"

module FloodRiskEngine

  RSpec.describe EnrollmentExemption do
    it { is_expected.to belong_to(:accept_reject_decision_user) }

    describe "approval" do
      let(:enrollment) { create(:approved_individual) }

      let(:ee) { enrollment.enrollment_exemptions.first }

      it "has a factory that assigns approved values" do
        expect(ee.accept_reject_decision_user).to be_a User
        expect(ee.accept_reject_decision_at).to be_a ActiveSupport::TimeWithZone
      end

      it "can reach the user email" do
        expect(ee.accept_reject_decision_user.email).to match(/.*@.*/)
      end
    end

    describe "scopes" do
      before do
        create_list(:submitted_local_authority, 5)
        create_list(:submitted_partnership, 5)

        create_list(:approved_individual, 4)
        create_list(:rejected_other, 2)
      end

      let(:from_date) { 1.year.ago }

      it "selects all completed" do
        expect(EnrollmentExemption.reportable_by_submitted_at(from_date, Date.current).count).to eq 16
      end

      it "selects only approved/rejected" do
        expect(EnrollmentExemption.reportable_by_decision_at(from_date, Date.current).count).to eq 6
      end
    end
  end
end
