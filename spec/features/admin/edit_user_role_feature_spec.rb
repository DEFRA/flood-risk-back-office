RSpec.describe "As an System user, I want to edit another user's role" do
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

  before do
    User.destroy_all
  end

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
end
