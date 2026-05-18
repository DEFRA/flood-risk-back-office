RSpec.describe "Temporary welcome feature" do
  it "Visiting the home-page shows the User 'sign in' form" do
    visit root_path
    expect(page).to have_text "Sign in"
  end
end
