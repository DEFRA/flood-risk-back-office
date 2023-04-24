require "rails_helper"

RSpec.describe "Edit correspondence contact", type: :feature do
  let(:enrollment_exemption) { create(:submitted_partnership).enrollment_exemptions.first }
  let(:user) { create(:user) }

  before do
    user.grant :system
    login_as user
    visit admin_enrollment_exemption_path(enrollment_exemption)

    within("#correspondence-contact-details") { click_link("Edit") }
  end

  it "successfully" do
    fill_in "Full name", with: "Alice Apples"
    fill_in "Position (optional)", with: "Ms"
    fill_in "Email address", with: "alice@example.com"
    fill_in "Telephone number", with: "07777777777"

    click_on "Continue"

    within("#correspondence-contact-details") do
      expect(page).to have_text("Alice Apples")
      expect(page).to have_text("Position: Ms")
      expect(page).to have_text("alice@example.com")
      expect(page).to have_text("07777777777")
    end
  end

  it "unsuccessfully" do
    fill_in "Email address", with: "foo-bar"
    click_on "Continue"

    expect(page).to have_css(".govuk-error-message", text: "Error: Enter a valid email address")
  end
end
