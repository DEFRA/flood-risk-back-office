RSpec.feature "As a user, I want to be able sign in" do
  let(:user) { create :user, password: "Abc12345678" }

  background do
    visit new_user_session_path
  end

  scenario "Automplete is off on the sign in form and password fields" do
    form = page.find("form")
    expect(form[:autocomplete]).to eq("off")

    pwd_input = page.find("input[type='password']")
    expect(pwd_input[:autocomplete]).to eq("off")
  end

  scenario "Sign in successfully" do
    fill_in "Email", with: user.email
    fill_in "Password", with: "Abc12345678"
    click_button I18n.t("devise.sign_in")

    expect(page).to have_flash I18n.t("devise.sessions.signed_in")
    expect(current_path).to eq "/"
  end

  scenario "Invalid sign in" do
    fill_in "Email", with: user.email
    fill_in "Password", with: "Xyz12345678"
    click_button I18n.t("devise.sign_in")

    expect(page).to have_flash(I18n.t("devise.failure.invalid", authentication_keys: "email"), key: :alert)
    expect(current_path).to eq new_user_session_path
  end

  scenario "Invalid sign in (nothing populated)" do
    click_button I18n.t("devise.sign_in")

    expect(page).to have_flash(I18n.t("devise.failure.invalid", authentication_keys: "email"), key: :alert)
    expect(current_path).to eq new_user_session_path
  end

  scenario "Log out" do
    login_as user
    visit "/"

    click_link I18n.t("devise.sign_out")
    expect(page).to have_flash I18n.t("devise.sessions.signed_out")
    expect(current_path).to eq "/"
  end
end
