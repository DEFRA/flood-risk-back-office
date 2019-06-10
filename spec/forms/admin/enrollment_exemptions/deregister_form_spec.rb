require "rails_helper"
require "shoulda/matchers"

module Admin
  module EnrollmentExemptions
    RSpec.describe DeregisterForm, type: :form do
      let(:user) { FactoryBot.create(:user) }
      let(:enrollment_exemption) { FactoryBot.create(:enrollment_exemption) }
      let(:form) { described_class.new(enrollment_exemption, user) }
      let(:comment) { Faker::Lorem.paragraph }
      let(:status) { :deregistered }
      let(:deregister_reasons) { enrollment_exemption.class.deregister_reasons.keys }
      let(:deregister_reason) { deregister_reasons.last }
      let(:params) do
        {
          form.params_key => {
            comment: comment,
            deregister_reason: deregister_reason
          }
        }
      end

      describe "#validate" do
        it "should return true if params valid" do
          expect(form.validate(params)).to be(true)
        end

        it "should validate status" do
          expect(form).to validate_inclusion_of(:deregister_reason)
            .in_array(form.reasons)
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

        it "should add a comment" do
          expect { form.save }.to change { FloodRiskEngine::Comment.count }.by(1)
        end

        context "after save" do
          before { form.save }

          it "should save the comment to a Comment model" do
            expect(FloodRiskEngine::Comment.last.content).to eq(comment)
          end

          it "should save the status to the enrollment_exemption" do
            expect(enrollment_exemption.reload.status).to eq(status.to_s)
          end

          it "should save the deregister reason" do
            expect(enrollment_exemption.reload.deregister_reason).to eq(deregister_reason)
          end
        end
      end

      describe "#reasons" do
        it "should return an array of valid deregister reasons" do
          expect(described_class.reasons).to eq(deregister_reasons)
        end
      end
    end
  end
end
