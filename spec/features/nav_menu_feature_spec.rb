RSpec.describe "Admin menu" do
  context "Logged out" do
    it "View logged-out admin menu" do
      visit main_app.root_path

      within "#navigation" do
        click_link t("devise.sign_in")
      end

      expect(page).to have_current_path new_user_session_path, ignore_query: true
    end
  end

  context "Logged in" do
    let(:user) { FactoryBot.create(:user) }

    before { login_as user }

    it "View logged-in admin menu (user with NCC super-agent role)" do
      user.add_role :super_agent
      visit main_app.root_path

      # to avoid Capybara/NegationMatcherAfterVisit
      expect(page).to have_link("Search")

      expect(page).to have_no_content t("devise.invite_user")

      within "#navigation" do
        expect(page).to have_link("Search")
        expect(page).to have_link("New")
        expect(page).to have_link("Export")
        expect(page).to have_no_link("Users")

        click_link t("devise.sign_out")
      end

      expect(page).to have_flash t("devise.sessions.signed_out")
    end

    it "View logged-in admin menu (user with NCC system role)" do
      user.add_role :system
      visit main_app.root_path

      within "#navigation" do
        expect(page).to have_link("Search")
        expect(page).to have_link("New")
        expect(page).to have_link("Export")
        expect(page).to have_link("Users")

        click_link t("devise.sign_out")
      end

      expect(page).to have_current_path root_path, ignore_query: true
    end
  end
end
