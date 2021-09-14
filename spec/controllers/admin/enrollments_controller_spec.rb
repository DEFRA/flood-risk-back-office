require "rails_helper"

module Admin
  RSpec.describe EnrollmentsController, type: :controller do
    include Devise::Test::ControllerHelpers

    let(:user) do
      user = FactoryBot.create(:user)
      user.add_role :system
      user
    end

    before do
      sign_in user
    end

    describe "new action" do
      before do
        get :new
      end

      it "should redirect to engine's initial step path" do
        expect(response).to be_redirect
        expect(response.location).to match("steps/add_exemptions")
      end
    end
  end
end
