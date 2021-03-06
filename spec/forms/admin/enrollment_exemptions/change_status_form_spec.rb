require "rails_helper"
require "shoulda/matchers"

module Admin
  module EnrollmentExemptions

    RSpec.describe ChangeStatusForm, type: :form do
      let(:user) { FactoryBot.create(:user) }
      let(:enrollment_exemption) { FactoryBot.create(:enrollment_exemption) }
      let(:form) { described_class.new(enrollment_exemption, user) }
      let(:comment) { Faker::Lorem.paragraph }
      let(:status) { "being_processed" }
      let(:params) do
        {
          form.params_key => {
            comment: comment,
            status: status
          }
        }
      end

      describe "pre-test status" do
        it "enrollment_exemption should not already be in status" do
          expect(enrollment_exemption.reload.status).not_to eq(status)
        end
      end

      describe "#validate" do
        it "should return true if params valid" do
          expect(form.validate(params)).to be(true)
        end

        context "with a very long comment" do
          let(:comment) { "a" * (described_class::COMMENT_MAX_LENGTH + 1) }
          it "should fail to validate" do
            expect(form.validate(params)).to be_falsy
          end
        end

        it "should validate comment presence" do
          expect(form).to validate_presence_of(:comment)
            .with_message(described_class.t(".errors.comment.blank"))
        end
      end

      describe "#save" do
        before do
          form.validate(params)
        end

        it "should add a comment" do
          expect { form.save }.to change { FloodRiskEngine::Comment.count }.by(1)
        end

        context "after save" do
          before { form.save }

          it "should save the comment to a Comment model" do
            expect(FloodRiskEngine::Comment.last.content).to eq(comment)
          end

          it "should change enrollment_exemption to the new status" do
            expect(enrollment_exemption.reload.status).to eq(status)
          end
        end
      end
    end
  end
end
