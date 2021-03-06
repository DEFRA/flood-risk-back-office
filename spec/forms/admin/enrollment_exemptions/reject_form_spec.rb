require "rails_helper"
require "shoulda/matchers"

module Admin
  module EnrollmentExemptions
    RSpec.describe RejectForm, type: :form do
      let(:user) { FactoryBot.create(:user) }
      let(:enrollment_exemption) { FactoryBot.create(:enrollment_exemption) }
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

        it "should validate comment presence" do
          expect(form).to validate_presence_of(:comment)
            .with_message(described_class.t(".errors.comment.blank"))
        end

        context "with a very long comment" do
          let(:comment) { "a" * (described_class::COMMENT_MAX_LENGTH + 1) }
          it "should fail to validate" do
            expect(form.validate(params)).to be_falsy
          end
        end
      end

      describe "#save" do
        before do
          form.validate(params)
        end

        context "with email service mocked" do
          before do
            allow_any_instance_of(SendRegistrationRejectedEmail)
              .to receive(:call)
              .and_return(true)
          end

          it "should add a comment" do
            expect { form.save }.to change { FloodRiskEngine::Comment.count }.by(1)
          end

          it "should save the comment to a Comment model" do
            form.save
            expect(FloodRiskEngine::Comment.last.content).to eq(comment)
          end

          it "should save the status rejected to the enrollment_exemption" do
            form.save
            expect(enrollment_exemption.reload.rejected?).to eq(true)
          end
        end

        it "should send a rejection email" do
          expect_any_instance_of(SendRegistrationRejectedEmail)
            .to receive(:call)
            .and_return(true)

          form.save
        end
      end
    end
  end
end
