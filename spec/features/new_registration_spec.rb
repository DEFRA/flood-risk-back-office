RSpec.describe "New scenario" do
  let(:user) { create(:user).tap { |u| u.add_role :system } }

  before { login_as(user) }

  it "in general" do
    visit main_app.root_path

    within("#navigation") { click_link("New") }

    expect(page).to have_css("h2", text: "Before you register you must")

    # check that the navigation links are no longer visible
    expect(page).not_to have_css("#navigation")
  end
end
