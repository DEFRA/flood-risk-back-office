require "rails_helper"
require "shoulda/matchers"

module Admin
  module EnrollmentExemptions
    RSpec.describe InProgressForm, type: :form do
      let(:user) { FactoryGirl.create(:user) }
      let(:enrollment_exemption) { FactoryGirl.create(:enrollment_exemption) }
      let(:form) { described_class.new(enrollment_exemption, user) }

      let(:params) do
        { form.params_key => {} }
      end

      describe "#validate" do
        it "should return true as no params to validate" do
          expect(form.validate(params)).to be(true)
        end
      end

      describe "#save" do
        it "should add a comment" do
          expect { form.save }.to change { FloodRiskEngine::Comment.count }.by(1)
        end

        context "after save" do
          before {
            expect(enrollment_exemption.being_processed?).to eq(false)
            form.save
          }

          it "should save the comment to a Comment model" do
            expect(FloodRiskEngine::Comment.last.event).to eq("Status changed to In Progress")
          end

          it "should set the User to the current logged in BO user" do
            expect(enrollment_exemption.accept_reject_decision_user).to eq user
            expect(enrollment_exemption.accept_reject_decision_user_id).to eq user.id
          end

          it "should save the status in_progressd to the enrollment_exemption" do
            expect(enrollment_exemption.reload.being_processed?).to eq(true)
          end
        end
      end
    end

  end
end
