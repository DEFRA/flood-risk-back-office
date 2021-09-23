require "rails_helper"

RSpec.describe "Resend an approval email", type: :feature do
  let(:enrollment_exemption) { create(:approved_limited_company).enrollment_exemptions.first }
  let(:user) { create(:user) }

  before do
    user.grant :system
    login_as user
    visit admin_enrollment_exemption_path(enrollment_exemption)

    within("#actions") { click_link("Reissue approval email") }
  end

  scenario "successfully" do
    expect(SendRegistrationApprovedEmail).to receive(:for).once

    fill_in "Comment", with: "Reissued by Alice!"
    click_on "Confirm and send email"

    within("#comment-history") do
      expect(page).to have_text("#{user.email} - Reissued by Alice!")
      expect(page).to have_text("Reissued registration approved email")
    end
  end

  scenario "unsuccessfully" do
    click_on "Confirm and send email"

    expect(page).to have_css(".govuk-error-message", text: "Enter a comment")
  end
end
