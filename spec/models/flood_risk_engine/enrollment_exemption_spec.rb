require "rails_helper"

module FloodRiskEngine

  RSpec.describe EnrollmentExemption, type: :model do
    it { is_expected.to belong_to(:accept_reject_decision_user) }

    describe "approval" do
      let(:enrollment) { FactoryGirl.create(:approved_individual) }

      let(:ee) { enrollment.enrollment_exemptions.first }

      it "has a factory that assigns approved values" do
        expect(ee.accept_reject_decision_user).to be_a User
        expect(ee.accept_reject_decision_at).to be_a ActiveSupport::TimeWithZone
      end

      it "can reach the user email" do
        expect(ee.accept_reject_decision_user.email).to match(/.*@.*/)
      end
    end
  end
end
