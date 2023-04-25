RSpec.describe "As a user, I want to be unlock my account" do
  include ActiveSupport::Testing::TimeHelpers

  let(:user) { create :user, password: "Xyz12345678" }

  before do
    3.times do
      expect(user.reload.locked_at).to be_nil
      expect(user.unlock_token).to be_blank

      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Password", with: SecureRandom.hex(10).titleize
      expect do
        click_button I18n.t("devise.sign_in")
        expect(page).to have_flash(I18n.t("devise.failure.invalid", authentication_keys: "email"), key: :alert)
      end.to change { user.reload.failed_attempts }.by(1)
    end
  end

  it "Lock account" do
    expect(user.reload.locked_at).to be_kind_of ActiveSupport::TimeWithZone
    expect(user.unlock_token).to be_present

    expect(mailbox_for(user.email)).to be_one
    open_email user.email
    # EmailSpec::EmailViewer.save_and_open_email(current_email)
    expect(current_email).to have_subject I18n.t("devise.mailer.unlock_instructions.subject")
    expect(current_email.default_part_body.to_s).to include("We received a request to unlock your account")
  end

  it "Unlock account by email" do
    reset_mailer

    visit new_user_unlock_path
    fill_in "Email", with: user.email
    click_button I18n.t("devise.resend_unlock_instructions")
    expect(page).to have_flash I18n.t("devise.unlocks.send_paranoid_instructions")

    expect(mailbox_for(user.email)).to be_one
    open_email user.email
    visit_in_email "Unlock your account"

    expect(page).to have_flash I18n.t("devise.unlocks.unlocked")
    expect(page).to have_current_path new_user_session_path, ignore_query: true

    expect(user.reload.failed_attempts).to eq 0
    expect(user.reload.locked_at).to be_nil
    expect(user.unlock_token).to be_blank

    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button I18n.t("devise.sign_in")
    expect(page).to have_flash I18n.t("devise.sessions.signed_in")
  end

  it "Unlock account by waiting for unlock interval" do
    travel(29.minutes + 58.seconds) do
      visit new_user_session_path

      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button I18n.t("devise.sign_in")
      expect(page).to have_flash(I18n.t("devise.failure.invalid", authentication_keys: "email"), key: :alert)
      expect(user.reload.locked_at).to be_kind_of ActiveSupport::TimeWithZone
      expect(user.unlock_token).to be_present
    end

    travel(30.minutes + 2.seconds) do
      visit new_user_session_path

      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button I18n.t("devise.sign_in")
      expect(page).to have_flash I18n.t("devise.sessions.signed_in")

      expect(user.reload.locked_at).to be_nil
      expect(user.unlock_token).to be_nil
    end
  end
end
