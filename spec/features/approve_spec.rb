require "rails_helper"

RSpec.describe "Approve an enrollment", type: :feature do
  let(:enrollment_exemption) { create(:submitted_limited_company).enrollment_exemptions.first }
  let(:user) { create(:user) }

  before do
    user.grant :system
    login_as user
    visit admin_enrollment_exemption_path(enrollment_exemption)

    within("#actions") { click_link("Approve") }
  end

  scenario "successfully" do
    expect(SendRegistrationApprovedEmail).to receive(:for).once

    check "Asset found"
    check "Salmonid river found"
    fill_in "Comment", with: "Approved by Alice!"
    click_on "Confirm and send email"

    within("#status") { expect(page).to have_text("Approved") }
    within("#comment-history") { expect(page).to have_text("Approved by Alice!") }

    ee = enrollment_exemption.reload
    expect(ee.accept_reject_decision_user_id).to be_present
    expect(ee.accept_reject_decision_at).to be_present
    expect(ee.salmonid_river_found).to be_truthy
    expect(ee.asset_found).to be_truthy
  end

  scenario "unsuccessfully" do
    click_on "Confirm and send email"

    expect(page).to have_css(".govuk-error-message", text: "Enter a comment")
  end
end
