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
    end
  end
end
