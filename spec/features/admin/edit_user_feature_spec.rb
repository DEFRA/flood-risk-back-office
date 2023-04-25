# frozen_string_literal: true

RSpec.describe "Edit users" do
  let(:system_user) {
    u = create(:user)
    u.add_role :system
    u
  }
  let(:other_user) {
    u = create(:user)
    u.add_role :admin_agent
    u
  }

  describe "As a System user, I want to edit another user's details" do

    context "unauthorised" do
      it "Logged out user is asked to sign-in" do
        # don't sign in
        visit edit_admin_user_path(other_user)
        expect(page).to have_current_path new_user_session_path, ignore_query: true
        expect(page).to have_flash(I18n.t("devise.failure.unauthenticated"), key: :alert)
      end

      it "User without role is denied access" do
        login_as create(:user)
        visit edit_admin_user_path(other_user)

        expect(page).to have_current_path main_app.root_path, ignore_query: true
        expect(page).to have_flash(I18n.t("pundit.defaults.edit?", name: "user"), key: :alert)
      end

      %i[super_agent admin_agent data_agent].each do |role|
        it "#{role.to_s.humanize} user is denied access" do
          user = create :user
          user.add_role role
          login_as user
          visit edit_admin_user_path(other_user)

          expect(page).to have_current_path main_app.root_path, ignore_query: true
          expect(page).to have_flash(I18n.t("pundit.defaults.edit?", name: "user"), key: :alert)
        end
      end
    end

    context "authorised" do
      let(:system_user) { create(:user) }
      let(:other_user) { create(:user) }

      before do
        system_user.grant :system
        login_as system_user
      end

      it "can load the edit view" do
        visit edit_admin_user_path(other_user)

        expect(page).to have_text(/Edit user.*#{other_user.email}/)
      end

      it "can update another user's role" do
        visit edit_admin_user_path(other_user)
        select "Administrative user", from: "Role"
        click_on "Update User"

        expect(other_user.has_role?(:admin_agent)).to be true
      end
    end
  end
end
