RSpec.feature "As an System user, I want to disable/enable a user" do
  let!(:system_user) do
    create(:user).tap { |u| u.add_role :system }
  end

  let!(:other_user) do
    create(:user).tap { |u| u.add_role :admin_agent }
  end

  background do
    User.destroy_all
  end

  context "authorised" do
    # Disabling a user is tested below but it veers off into an
    # authentication test. Here we are concerned with toggling the
    # user's status
    scenario "Disable / Enable a user" do
      system_user = create(:user).tap { |u| u.add_role :system }
      other_user = create(:user).tap { |u| u.add_role :admin_agent }

      login_as system_user
      visit admin_users_path

      click_link "Disable"
      fill_in "Comment", with: "User has left the company"
      click_button "Disable user"
      click_link "Show all users"
      expect(page).to have_css("tr#user_#{other_user.id} td", text: "Disabled")

      click_link "Enable"
      expect(page).to have_css("h1", text: "You are about to enable the user #{other_user.email}")
      click_button "Yes, continue"
      expect(page).to have_css("tr#user_#{other_user.id} td", text: "Enabled")
    end

    scenario "System user can disable another user", versioning: true do
      system_user = create(:user).tap { |u| u.add_role :system }
      other_user = create(:user).tap { |u| u.add_role :admin_agent }

      login_as system_user
      visit admin_user_edit_disable_path(other_user)

      fill_in "Comment", with: "User has left the company"

      expect do
        expect do
          click_button "Disable user"
          expect(page).to have_flash I18n.t("user_disabled_success", name: other_user.email)
        end.to change { other_user.reload.disabled_at }.from(nil)
      end.to change { other_user.reload.versions.count }.by(1)

      expect(current_path).to eq admin_users_path

      expect(other_user).to be_disabled
      expect(other_user.disabled_at).to be_kind_of ActiveSupport::TimeWithZone
      expect(other_user.disabled_comment).to eq "User has left the company"

      last_version = other_user.versions.last
      expect(last_version.reify).to be_enabled
      expect(last_version.whodunnit).to eq system_user.id.to_s

      logout :user
      visit new_user_session_path
      fill_in "Email", with: other_user.email
      fill_in "Password", with: other_user.password

      # rubocop:disable Lint/AmbiguousBlockAssociation
      expect do
        click_button "Sign in"
      end.to_not change { other_user.reload.sign_in_count }
      # rubocop:enable Lint/AmbiguousBlockAssociation

      # Devise "paranoid mode" is on, so display the message "Invalid email or password",
      # instead of the default "Your account is not activated yet" message
      expect(page).to have_flash(I18n.t("devise.failure.invalid", authentication_keys: "email"), key: :alert)
    end
  end

  context "unauthorised" do
    scenario "Logged out user is asked to sign-in" do
      # don't sign in
      visit admin_user_edit_disable_path(other_user)

      expect(current_path).to eq new_user_session_path
      expect(page).to have_flash(I18n.t("devise.failure.unauthenticated"), key: :alert)
    end
  end
end
