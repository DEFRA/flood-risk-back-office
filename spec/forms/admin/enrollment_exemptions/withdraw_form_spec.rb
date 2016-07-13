require "rails_helper"
require "shoulda/matchers"

module Admin
  module EnrollmentExemptions
    RSpec.describe WithdrawForm, type: :from do
      let(:user) { FactoryGirl.create(:user) }
      let(:enrollment_exemption) { FactoryGirl.create(:enrollment_exemption) }
      let(:form) { described_class.new(enrollment_exemption, user) }
      let(:comment) { Faker::Lorem.paragraph }
      let(:params) do
        {
          form.params_key => {
            comment: comment
          }
        }
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

        context "with a blank comment" do
          let(:comment) { "" }
          it "should fail to validate" do
            expect(form.validate(params)).to be_falsy
          end
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

          it "should save the status withdrawn to the enrollment_exemption" do
            expect(enrollment_exemption.reload.withdrawn?).to eq(true)
          end
        end
      end
    end
  end
end
