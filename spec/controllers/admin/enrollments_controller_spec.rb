require "rails_helper"

module Admin
  RSpec.describe EnrollmentsController, type: :controller do
    include Devise::TestHelpers
    let(:correspondence_contact) { FactoryBot.create(:contact) }
    let(:secondary_contact) { FactoryBot.create(:contact) }
    let(:organisation) do
      FactoryBot.create :organisation
    end
    let(:enrollment) do
      FactoryBot.create(
        :enrollment,
        submitted_at: Time.zone.now,
        correspondence_contact: correspondence_contact,
        secondary_contact: secondary_contact,
        organisation: organisation
      )
    end
    let(:enrollment_exemption) do
      FactoryBot.create(
        :enrollment_exemption,
        status: FloodRiskEngine::EnrollmentExemption.statuses[:pending],
        enrollment: enrollment
      )
    end
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

    describe "edit action" do
      before do
        get :edit, id: enrollment
      end

      it "should render page sucessfully" do
        expect(response).to have_http_status(:success)
      end
    end

    describe "update action" do
      let(:validation_pass) { true }
      let(:form) { Admin::EnrollmentForm.new(enrollment) }

      before do
        allow_any_instance_of(Admin::EnrollmentForm).to(
          receive(:validate).and_return(validation_pass)
        )
        allow_any_instance_of(Admin::EnrollmentForm).to(
          receive(:save).and_return(true)
        )
        enrollment_exemption # To ensure object built
        put :update, id: enrollment, form.params_key => {}
      end

      it "should redirect to enrollment_exemption" do
        expect(response).to redirect_to(
          controller: "admin/enrollment_exemptions",
          action: "show",
          id: enrollment_exemption
        )
      end

      context "on failure" do
        let(:validation_pass) { false }

        it "should render edit sucessfully" do
          expect(response).to have_http_status(:success)
          expect(response).to render_template(:edit)
        end
      end
    end
  end
end
