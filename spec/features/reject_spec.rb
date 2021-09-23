require "rails_helper"

RSpec.describe "Reject an enrollment", type: :feature do
  let(:enrollment_exemption) { create(:submitted_limited_company).enrollment_exemptions.first }
  let(:user) { create(:user) }

  before do
    user.grant :system
    login_as user
    visit admin_enrollment_exemption_path(enrollment_exemption)

    within("#actions") { click_link("Reject") }
  end

  scenario "successfully" do
    expect(SendRegistrationRejectedEmail).to receive(:for).once

    fill_in "Comment", with: "Rejected by Alice!"
    click_on "Confirm and send email"

    within("#status") { expect(page).to have_text("Rejected") }
    within("#comment-history") { expect(page).to have_text("#{user.email} - Rejected by Alice!") }

    ee = enrollment_exemption.reload
    expect(ee.accept_reject_decision_user_id).to be_present
    expect(ee.accept_reject_decision_at).to be_present
  end

  scenario "unsuccessfully" do
    click_on "Confirm and send email"

    expect(page).to have_css(".govuk-error-message", text: "Enter a comment")
  end
end
