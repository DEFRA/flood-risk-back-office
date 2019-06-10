RSpec.feature "Admin menu" do
  context "Logged out" do
    scenario "View logged-out admin menu" do
      visit main_app.root_path

      within "nav[role=navigation] ul.navbar-nav" do
        expect(page).to have_css("li", count: 1)
        click_link t("devise.sign_in")
      end

      expect(current_path).to eq new_user_session_path
    end
  end

  context "Logged in" do
    let(:user) { FactoryBot.create :user }
    background { login_as user }

    scenario "View logged-in admin menu (user with NCC super-agent role)" do
      user.add_role :super_agent
      visit main_app.root_path

      expect(page).to have_no_content t("devise.invite_user")

      within "nav[role=navigation] ul.navbar-nav" do
        expect(page).to have_css("> li", count: 2)

        expect(page).to have_css("ul.dropdown-menu > li", count: 3)

        click_link t("devise.sign_out")
      end

      expect(page).to have_flash t("devise.sessions.signed_out")
    end

    scenario "View logged-in admin menu (user with NCC system role)" do
      user.add_role :system
      visit main_app.root_path

      expect(page).to have_content t("devise.invite_user")

      within "nav[role=navigation] ul.navbar-nav" do
        expect(page).to have_css("> li", count: 3)

        expect(page).to have_css("ul.dropdown-menu > li", count: 5)

        click_link t("devise.invite_user")
      end

      expect(current_path).to eq new_user_invitation_path
    end
  end
end
