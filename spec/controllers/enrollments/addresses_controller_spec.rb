require "rails_helper"

module Enrollments
  RSpec.describe AddressesController, type: :controller do
    include Devise::Test::ControllerHelpers

    let(:enrollment) do
      FactoryBot.create(
        :enrollment,
        submitted_at: Time.zone.now
      )
    end
    let(:enrollment_exemption) do
      FactoryBot.create(
        :enrollment_exemption,
        status: FloodRiskEngine::EnrollmentExemption.statuses[:pending],
        enrollment: enrollment
      )
    end
    let(:address) { FactoryBot.create(:simple_address) }
    let(:user) do
      user = FactoryBot.create(:user)
      user.add_role :system
      user
    end

    before do
      enrollment_exemption
      sign_in user
    end

    describe "edit action" do
      before do
        get :edit, params: { id: address, enrollment_id: enrollment }
      end

      it "should render page sucessfully" do
        expect(response).to have_http_status(:success)
      end
    end

    describe "update action" do
      before do
        expect_any_instance_of(AddressForm).to(
          receive(:validate).and_return(validation_result)
        )
        put(
          :update,
          params: {
            id: address,
            enrollment_id: enrollment,
            flood_risk_engine_address: address.attributes
          }
        )
      end

      context "on success" do
        let(:validation_result) { true }

        it "should redirect to the enrollment's next step on success" do
          expect(response).to redirect_to(
            admin_enrollment_exemption_path(enrollment_exemption)
          )
        end
      end

      context "failure" do
        let(:validation_result) { false }

        it "should display edit template" do
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:edit)
        end
      end
    end
  end
end
