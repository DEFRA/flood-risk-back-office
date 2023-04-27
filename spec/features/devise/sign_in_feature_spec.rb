RSpec.describe "As a user, I want to be able sign in" do
  let(:user) { create(:user, password: "Abc12345678") }

  before do
    visit new_user_session_path
  end

  it "Automplete is off on the sign in form and password fields" do
    form = page.find("form")
    expect(form[:autocomplete]).to eq("off")

    pwd_input = page.find("input[type='password']")
    expect(pwd_input[:autocomplete]).to eq("off")
  end

  it "Sign in successfully" do
    fill_in "Email", with: user.email
    fill_in "Password", with: "Abc12345678"
    click_button I18n.t("devise.sign_in")

    expect(page).to have_flash I18n.t("devise.sessions.signed_in")
    expect(page).to have_current_path "/"
  end

  it "Invalid sign in" do
    fill_in "Email", with: user.email
    fill_in "Password", with: "Xyz12345678"
    click_button I18n.t("devise.sign_in")

    expect(page).to have_flash(I18n.t("devise.failure.invalid", authentication_keys: "email"), key: :alert)
    expect(page).to have_current_path new_user_session_path, ignore_query: true
  end

  it "Invalid sign in (nothing populated)" do
    click_button I18n.t("devise.sign_in")

    expect(page).to have_flash(I18n.t("devise.failure.invalid", authentication_keys: "email"), key: :alert)
    expect(page).to have_current_path new_user_session_path, ignore_query: true
  end

  it "Log out" do
    login_as user
    visit "/"

    click_link I18n.t("devise.sign_out")
    expect(page).to have_flash I18n.t("devise.sessions.signed_out")
    expect(page).to have_current_path "/"
  end
end
