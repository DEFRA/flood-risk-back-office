require "rails_helper"

RSpec.describe "Edit secondary contact", type: :feature do
  let(:enrollment_exemption) { create(:submitted_partnership).enrollment_exemptions.first }
  let(:user) { create(:user) }

  before do
    user.grant :system
    login_as user
    visit admin_enrollment_exemption_path(enrollment_exemption)

    within("#secondary-contact-details") { click_link("Edit") }
  end

  scenario "successfully" do
    fill_in "Email address", with: "alice@example.com"
    click_on "Continue"

    within("#secondary-contact-details") do
      expect(page).to have_text("alice@example.com")
      expect(page).to have_link("Edit")
    end
  end

  scenario "unsuccessfully" do
    fill_in "Email address", with: "foo-bar"
    click_on "Continue"

    expect(page).to have_css(".govuk-error-message", text: "Error: Enter a valid email address")
  end
end
