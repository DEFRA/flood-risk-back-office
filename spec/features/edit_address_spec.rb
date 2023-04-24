require "rails_helper"

RSpec.describe "Edit address", type: :feature do
  let(:enrollment_exemption) { create(:submitted_limited_company).enrollment_exemptions.first }
  let(:user) { create(:user) }

  before do
    user.grant :system
    login_as user
    visit admin_enrollment_exemption_path(enrollment_exemption)

    within("#address") { click_link("Edit") }
  end

  it "successfully" do
    fill_in "Building name or number", with: "10"
    fill_in "Address line 1", with: "Downing St"
    fill_in "Address line 2 (optional)", with: "Horseguards Parade"
    fill_in "Town or city", with: "That London"
    fill_in "Postcode", with: "SW1A 2AA"
    click_on "Continue"

    within("#address") do
      expect(page).to have_text("10, Downing St, Horseguards Parade, That London, SW1A 2AA")
    end
  end

  it "unsuccessfully" do
    fill_in "Postcode", with: "foo-bar-foo"
    click_on "Continue"

    expect(page).to have_css(".govuk-error-message", text: "Postcode is too long")
  end
end
