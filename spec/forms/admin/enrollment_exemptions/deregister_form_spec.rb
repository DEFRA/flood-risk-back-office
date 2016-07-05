require "rails_helper"
require "shoulda/matchers"

module Admin
  module EnrollmentExemptions
    RSpec.describe DeregisterForm, type: :form do
      let(:user) { FactoryGirl.create(:user) }
      let(:enrollment_exemption) { FactoryGirl.create(:enrollment_exemption) }
      let(:form) { described_class.new(enrollment_exemption, user) }
      let(:comment) { Faker::Lorem.paragraph }
      let(:status) { described_class.statuses.last }
      let(:params) do
        {
          form.params_key => {
            comment: comment,
            status: status
          }
        }
      end

      describe "#validate" do
        it "should return true if params valid" do
          expect(form.validate(params)).to be(true)
        end

        it "should validate status" do
          expect(form).to validate_inclusion_of(:status)
            .in_array(form.statuses)
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

        it "should save the comment to a Comment model" do
          form.save
          expect(FloodRiskEngine::Comment.last.content).to eq(comment)
        end

        it "should save the status to the enrollment_exemption" do
          form.save
          expect(enrollment_exemption.reload.status).to eq(status)
        end
      end

      describe "#statuses" do
        it "should return an array of valid statuses" do
          expect(described_class.statuses.sort).to eq(%w(expired withdrawn))
        end

        context "a status is removed" do
          let(:fake_class) { double(statuses: { "expired" => 1 }) }
          before do
            stub_const("FloodRiskEngine::EnrollmentExemption", fake_class)
            described_class.remove_instance_variable(:@statuses)
          end

          it "should return an array of valid statuses" do
            expect(described_class.statuses.sort).to eq(["expired"])
          end
        end
      end
    end
  end
end
