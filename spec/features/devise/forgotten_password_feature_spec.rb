RSpec.describe "As user, I want to be able to reset my password if I forget it" do
  before do
    visit new_user_password_path
  end

  context "With valid user input" do
    let!(:user) { create(:user) }

    before do
      fill_in "Enter the email address associated with your account", with: user.email
      click_button I18n.t("devise.send_password_reset_instructions")
      expect(page).to have_flash I18n.t("devise.passwords.send_paranoid_instructions")

      expect(mailbox_for(user.email)).to be_one
      open_email user.email
      expect(current_email).to have_subject I18n.t("devise.mailer.reset_password_instructions.subject")
      expect(current_email.default_part_body.to_s).to include("We received a password reset request for your account")

      visit_in_email I18n.t("devise.change_password")
      expect(page).to have_current_path edit_user_password_path, ignore_query: true
    end

    it "Form and password fields have autocomplete off" do
      form = page.find("form")
      expect(form[:autocomplete]).to eq("off")

      the_two_password_fields = page.all("input[type='password']")
      expect(the_two_password_fields.count).to eq(2)
      expect(the_two_password_fields.pluck(:autocomplete).uniq).to eq ["off"]
    end

    it "Retreive lost password (valid)" do
      new_password = "1234abcdeF"
      fill_in I18n.t("devise.new_password"), with: new_password
      fill_in I18n.t("devise.confirm_new_password"), with: new_password
      click_button I18n.t("devise.change_password")

      expect(page).to have_flash I18n.t("devise.passwords.updated_not_active")

      logout :user
      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button I18n.t("devise.sign_in")

      expect(page).to have_flash(I18n.t("devise.failure.invalid", authentication_keys: "email"), key: :alert)

      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: new_password
      click_button I18n.t("devise.sign_in")

      expect(page).to have_no_content I18n.t("devise.failure.invalid", authentication_keys: "email")
      expect(page).to have_flash I18n.t("devise.sessions.signed_in")
      expect(page).to have_current_path "/"
    end

    it "Retreive lost password (invalid new password)" do
      fill_in I18n.t("devise.new_password"), with: "654321"
      click_button I18n.t("devise.change_password")

      key = "activerecord.errors.models.user.attributes.password.too_short.other"
      expect(page).to have_css(
        "#user-password-error", text: I18n.t(key, count: 8)
      )

      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button I18n.t("devise.sign_in")
      expect(page).to have_current_path "/"
    end

    it "Retreive lost password (blank new password)" do
      click_button I18n.t("devise.change_password")
      key = "activerecord.errors.models.user.attributes.password.blank"
      expect(page).to have_css(
        "#user-password-error", text: I18n.t(key)
      )

      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button I18n.t("devise.sign_in")
      expect(page).to have_flash I18n.t("devise.sessions.signed_in")
      expect(page).to have_current_path "/"
    end
  end

  context "With invalid user input" do
    it "Retreive lost password (blank email)" do
      click_button I18n.t("devise.send_password_reset_instructions")

      expect(page).to have_flash I18n.t("devise.passwords.send_paranoid_instructions")
      expect(all_emails).to be_empty
    end

    it "Retreive lost password (non-existant email)" do
      fill_in "Enter the email address associated with your account", with: "wibble@wobble.com"
      click_button I18n.t("devise.send_password_reset_instructions")

      expect(page).to have_flash I18n.t("devise.passwords.send_paranoid_instructions")
      expect(all_emails).to be_empty
    end

    it "Retreive lost password (invalid token)" do
      visit edit_user_password_path(reset_password_token: "jNF5kVHc7R2EZ9fCQjt")
      fill_in "New password", with: "AbcFooBar1"
      fill_in "Confirm new password", with: "AbcFooBar1"
      click_button I18n.t("devise.change_password")

      expect(page).to have_css(
        ".govuk-error-summary",
        text: "It looks like you're trying to reset your password, but the URL you followed was invalid."
      )
    end
  end
end
