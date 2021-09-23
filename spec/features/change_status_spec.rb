require "rails_helper"

RSpec.describe "Change status", type: :feature do
  let(:enrollment_exemption) { create(:submitted_limited_company).enrollment_exemptions.first }
  let(:user) { create(:user) }

  before do
    user.grant :system
    login_as user
    visit admin_enrollment_exemption_path(enrollment_exemption)

    within("#actions") { click_link("Change status") }
  end

  scenario "successfully" do
    select "Withdrawn", from: "Status"
    fill_in "Comment", with: "Changed by Alice!"
    click_on "Confirm Update"

    within("#status") { expect(page).to have_text("Withdrawn") }
    within("#comment-history") do
      expect(page).to have_text("#{user.email} - Changed by Alice!")
      expect(page).to have_text("Changed exemption from #{enrollment_exemption.status} to withdrawn")
    end
  end

  scenario "unsuccessfully" do
    click_on "Confirm Update"

    expect(page).to have_css(".govuk-error-message", text: "Enter a comment")
  end
end
