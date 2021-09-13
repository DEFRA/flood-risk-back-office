require "rails_helper"

RSpec.describe "Edit address", type: :feature do
  let(:enrollment_exemption) { create(:submitted_partnership).enrollment_exemptions.first }
  let(:user) { create(:user) }

  before do
    user.grant :system
    login_as user
    visit admin_enrollment_exemption_path(enrollment_exemption)

    within("#partner-1") { click_link("Edit") }
  end

  scenario "successfully" do
    fill_in "Full name", with: "Alice Apples"
    fill_in "Building name or number", with: "10"
    fill_in "Address line 1", with: "Downing St"
    fill_in "Address line 2 (optional)", with: "Horseguards Parade"
    fill_in "Town or city", with: "That London"
    fill_in "Postcode", with: "SW1A 2AA"
    click_on "Continue"

    within("#partner-1") do
      expect(page).to have_text("Name: Alice Apples")
      expect(page).to have_text("Address: 10, Downing St, Horseguards Parade, That London, SW1A 2AA")
    end
  end

  scenario "unsuccessfully" do
    fill_in "Full name", with: ""
    click_on "Continue"

    expect(page).to have_css(".govuk-error-message", text: "Enter a full name")
  end
end
