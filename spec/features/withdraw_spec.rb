require "rails_helper"

RSpec.describe "Withdraw an enrollment", type: :feature do
  let(:enrollment_exemption) { create(:submitted_limited_company).enrollment_exemptions.first }
  let(:user) { create(:user) }

  before do
    user.grant :system
    login_as user
    visit admin_enrollment_exemption_path(enrollment_exemption)

    within("#actions") { click_link("Withdraw") }
  end

  scenario "successfully" do
    fill_in "Comment", with: "Withdrawn by Alice!"
    click_on "Withdraw"

    within("#status") { expect(page).to have_text("Withdrawn") }
    within("#comment-history") { expect(page).to have_text("Withdrawn by Alice!") }
  end

  scenario "unsuccessfully" do
    click_on "Withdraw"

    expect(page).to have_css(".govuk-error-message", text: "Enter a comment")
  end
end
