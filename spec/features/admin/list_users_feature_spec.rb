RSpec.describe "As an System user, I want to view a list of users" do
  before do
    User.destroy_all
  end

  context "authorised" do
    it "System user can view list of 'enable' users and toggle to view 'all'" do
      create_list :user, 2
      create_list :disabled_user, 2

      user = User.first
      user.grant :system
      login_as user
      visit admin_users_path
      expect(page).to have_css("tbody tr", count: 2)

      click_link "Show all users"
      expect(page).to have_css("tbody tr", count: 4)

      click_link "Show enabled users only"
      expect(page).to have_css("tbody tr", count: 2)
    end
  end

  context "unauthorised" do
    it "Logged out user is asked to sign-in" do
      # don't sign in
      visit admin_users_path
      expect(page).to have_current_path new_user_session_path, ignore_query: true
      expect(page).to have_flash(I18n.t("devise.failure.unauthenticated"), key: :alert)
    end

    it "User without role is denied access" do
      login_as create(:user)
      visit admin_users_path

      expect(page).to have_current_path main_app.root_path, ignore_query: true
      expect(page).to have_flash(I18n.t("pundit.defaults.index?", name: "users"), key: :alert)
    end

    %i[super_agent admin_agent data_agent].each do |role|
      it "#{role.to_s.humanize} user is denied access" do
        user = create :user
        user.add_role role
        login_as user
        visit admin_users_path

        expect(page).to have_current_path main_app.root_path, ignore_query: true
        expect(page).to have_flash(I18n.t("pundit.defaults.index?", name: "users"), key: :alert)
      end
    end
  end
end
