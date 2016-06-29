require "rails_helper"

module Admin
  module EnrollmentExemptions
    RSpec.describe RejectController, type: :controller do
      include Devise::TestHelpers

      render_views
      let(:enrollment_exemption) do
        FactoryGirl.create(
          :enrollment_exemption,
          status: FloodRiskEngine::EnrollmentExemption.statuses[:pending]
        )
      end
      let(:user) do
        user = FactoryGirl.create(:user)
        user.add_role :system
        user
      end

      before do
        sign_in user
      end

      describe "new action" do
        it "renders page" do
          get :new, enrollment_exemption_id: enrollment_exemption
          expect(response).to have_http_status(:success)
        end
      end

      describe "create action" do
        context "with success" do
          before do
            allow_any_instance_of(RejectForm).to receive(:validate).and_return(true)
            allow_any_instance_of(RejectForm).to receive(:save).and_return(true)
          end

          it "redirects to enrollment_exemption show" do
            post :create, enrollment_exemption_id: enrollment_exemption
            expect(response).to redirect_to(
              admin_enrollment_exemption_path(enrollment_exemption)
            )
          end
        end

        context "with failure" do
          before do
            allow_any_instance_of(RejectForm).to receive(:validate).and_return(false)
          end

          it "renders new template" do
            post :create, enrollment_exemption_id: enrollment_exemption
            expect(response).to have_http_status(:success)
            expect(response).to render_template(:new)
          end
        end
      end
    end
  end
end
