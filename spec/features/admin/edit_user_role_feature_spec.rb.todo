RSpec.feature "As an System user, I want to edit another user's role" do
  let(:system_user) do
    u = create(:user)
    u.add_role :system
    u
  end

  let(:other_user) do
    u = create(:user)
    u.add_role :admin_agent
    u
  end

  background do
    User.destroy_all
  end

  context "authorised" do
    scenario "System user can edit another user's role", versioning: true do
      login_as system_user
      visit edit_admin_user_path(other_user)

      select "Data user", from: "Role"

      expect do
        expect do
          click_button "Update user"
          expect(page).to have_flash I18n.t("user_update_success", name: other_user.email)
        end.to change { other_user.roles(true).pluck(:name) }.from(["admin_agent"]).to(["data_agent"])
      end.to change { other_user.reload.versions.count }.by(2)

      expect(current_path).to eq admin_users_path

      expect(other_user.role_names).to eq "data_agent"

      # Note: 2 "paper-trail" versions records are created,
      #       as any existing user role(s) are deleted before the new role is added
      #       which results in two updates to the user record
      last_version = other_user.versions.last
      expect(last_version.reify.role_names).to be_nil
      expect(last_version.whodunnit).to eq system_user.id.to_s

      prev_version = other_user.versions[-2]
      expect(prev_version.reify.role_names).to eq "admin_agent"
      expect(prev_version.whodunnit).to eq system_user.id.to_s
    end
  end

  context "unauthorised" do
    scenario "Logged out user is asked to sign-in" do
      # don't sign in
      visit edit_admin_user_path(other_user)
      expect(current_path).to eq new_user_session_path
      expect(page).to have_flash(I18n.t("devise.failure.unauthenticated"), key: :alert)
    end

    scenario "User without role is denied access" do
      login_as create(:user)
      visit edit_admin_user_path(other_user)

      expect(current_path).to eq main_app.root_path
      expect(page).to have_flash(I18n.t("pundit.defaults.edit?", name: "user"), key: :alert)
    end

    %i(super_agent admin_agent data_agent).each do |role|
      scenario "#{role.to_s.humanize} user is denied access" do
        user = create :user
        user.add_role role
        login_as user
        visit edit_admin_user_path(other_user)

        expect(current_path).to eq main_app.root_path
        expect(page).to have_flash(I18n.t("pundit.defaults.edit?", name: "user"), key: :alert)
      end
    end
  end
end
