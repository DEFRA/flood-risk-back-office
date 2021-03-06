RSpec.feature "As an System user, I want to view a list of users" do
  background do
    User.destroy_all
  end

  context "authorised" do
    scenario "System user can view user list" do
      create_list :user, 10
      user = User.first

      user.grant :system
      login_as user
      visit admin_users_path

      expect(page).to have_css("tbody tr", count: 10)
    end
  end

  context "unauthorised" do
    scenario "Logged out user is asked to sign-in" do
      # don't sign in
      visit admin_users_path
      expect(current_path).to eq new_user_session_path
      expect(page).to have_flash(I18n.t("devise.failure.unauthenticated"), key: :alert)
    end

    scenario "User without role is denied access" do
      login_as create(:user)
      visit admin_users_path

      expect(current_path).to eq main_app.root_path
      expect(page).to have_flash(I18n.t("pundit.defaults.index?", name: "users"), key: :alert)
    end

    %i[super_agent admin_agent data_agent].each do |role|
      scenario "#{role.to_s.humanize} user is denied access" do
        user = create :user
        user.add_role role
        login_as user
        visit admin_users_path

        expect(current_path).to eq main_app.root_path
        expect(page).to have_flash(I18n.t("pundit.defaults.index?", name: "users"), key: :alert)
      end
    end
  end
end
