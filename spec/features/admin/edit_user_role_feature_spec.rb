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

    %i[super_agent admin_agent data_agent].each do |role|
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
