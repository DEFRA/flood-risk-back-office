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
    scenario "System user can disable another user", versioning: true do
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

      expect do
        click_button "Sign in"
      end.to_not change { other_user.reload.sign_in_count }

      # Devise "paranoid mode" is on, so display the message "Invalid email or password",
      # instead of the default "Your account is not activated yet" message
      expect(page).to have_flash(I18n.t("devise.failure.invalid", authentication_keys: "email"), key: :alert)
    end

    scenario "System user can enable another user", versioning: true do
      other_user.disable! "Testing"

      login_as system_user
      visit admin_users_path

      expect do
        expect do
          within("tr#user_#{other_user.id}") { click_link "Enable" }
          expect(page).to have_flash I18n.t("user_enabled_success", name: other_user.email)
        end.to change { other_user.reload.disabled_at }.to(nil)
      end.to change { other_user.reload.versions.count }.by(1)

      expect(current_path).to eq admin_users_path

      expect(other_user).to be_enabled
      expect(other_user.disabled_at).to be_nil
      expect(other_user.disabled_comment).to be_nil

      last_version = other_user.versions.last
      expect(last_version.reify).to be_disabled
      expect(last_version.whodunnit).to eq system_user.id.to_s

      logout :user
      visit new_user_session_path
      fill_in "Email", with: other_user.email
      fill_in "Password", with: other_user.password

      expect do
        click_button "Sign in"
      end.to change { other_user.reload.sign_in_count }.by(1)

      expect(page).to have_flash I18n.t("devise.sessions.signed_in")
      expect(current_path).to eq "/"
    end
  end

  context "unauthorised" do
    scenario "Logged out user is asked to sign-in" do
      # don't sign in
      visit admin_user_edit_disable_path(other_user)

      expect(current_path).to eq new_user_session_path
      expect(page).to have_flash(I18n.t("devise.failure.unauthenticated"), key: :alert)
    end

    scenario "User without role is denied access" do
      login_as create(:user)
      visit admin_user_edit_disable_path(other_user)

      expect(current_path).to eq main_app.root_path
      expect(page).to have_flash(I18n.t("pundit.back_office_core/user_policy.disable?", name: "user"), key: :alert)
    end

    %i(super_agent admin_agent data_agent).each do |role|
      scenario "#{role.to_s.humanize} user is denied access" do
        user = create :user
        user.add_role role
        login_as user
        visit admin_user_edit_disable_path(other_user)

        expect(current_path).to eq main_app.root_path
        expect(page).to have_flash(I18n.t("pundit.back_office_core/user_policy.disable?", name: "user"), key: :alert)
      end
    end
  end
end
