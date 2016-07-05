require "rails_helper"
require "shoulda/matchers"

module Admin
  module EnrollmentExemptions
    RSpec.describe ApproveForm, type: :form do
      let(:user) { FactoryGirl.create(:user) }
      let(:enrollment_exemption) { FactoryGirl.create(:enrollment_exemption) }
      let(:form) { described_class.new(enrollment_exemption, user) }
      let(:comment) { Faker::Lorem.paragraph }
      let(:asset_found) { true }
      let(:salmonid_river_found) { false }
      let(:params) do
        {
          form.params_key => {
            comment: comment,
            asset_found: (asset_found ? 1 : 0).to_s,
            salmonid_river_found: (salmonid_river_found ? 1 : 0).to_s
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

        it "should validate comment presence" do
          expect(form).to validate_presence_of(:comment)
            .with_message(described_class.t(".errors.comment.blank"))
        end
      end

      describe "#save" do
        before do
          form.validate(params)
        end

        context "with email service mocked" do
          before do
            allow_any_instance_of(SendRegistrationApprovedEmail)
              .to receive(:call)
              .and_return(true)
          end

          it "should add a comment" do
            expect { form.save }.to change { FloodRiskEngine::Comment.count }.by(1)
          end

          context "after save" do
            before { form.save }

            it "should save the comment to a Comment model" do
              expect(FloodRiskEngine::Comment.last.content).to eq(comment)
            end

            it "should save the status approved to the enrollment_exemption" do
              expect(enrollment_exemption.reload.approved?).to eq(true)
            end

            context "with check boxes ticked" do
              let(:asset_found) { true }
              let(:salmonid_river_found) { true }

              it "should set asset_found true" do
                expect(enrollment_exemption.asset_found?).to eq(asset_found)
              end

              it "should set salmonid_river_found true" do
                expect(enrollment_exemption.salmonid_river_found?).to eq(salmonid_river_found)
              end
            end

            context "with check boxes unticked" do
              let(:asset_found) { false }
              let(:salmonid_river_found) { false }

              it "should set asset_found true" do
                expect(enrollment_exemption.asset_found?).to eq(asset_found)
              end

              it "should set salmonid_river_found true" do
                expect(enrollment_exemption.salmonid_river_found?).to eq(salmonid_river_found)
              end
            end
          end
        end

        it "should send a approval email" do
          expect_any_instance_of(SendRegistrationApprovedEmail)
            .to receive(:call)
            .and_return(true)

          form.save
        end
      end

      describe "#organisation_name" do
        let(:organisation) { FactoryGirl.create(:organisation) }
        let(:enrollment) do
          FactoryGirl.create(:enrollment, organisation: organisation)
        end

        let(:enrollment_exemption) do
          FactoryGirl.create(:enrollment_exemption, enrollment: enrollment)
        end

        it "should be present" do
          expect(form.organisation_name.present?).to eq(true)
        end

        it "should be the organisation name" do
          expect(form.organisation_name).to eq(organisation.name)
        end
      end
    end
  end
end
