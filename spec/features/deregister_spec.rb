require "rails_helper"

RSpec.describe "Deregister an enrollment", type: :feature do
  let(:enrollment_exemption) { create(:approved_limited_company).enrollment_exemptions.first }
  let(:user) { create(:user) }

  before do
    user.grant :system
    login_as user
    visit admin_enrollment_exemption_path(enrollment_exemption)

    within("#actions") { click_link("Deregister") }
  end

  scenario "successfully" do
    select "Operator failings", from: "Deregister reason"
    fill_in "Comment", with: "Deregistered by Alice!"
    click_on "Deregister registration"

    within("#status") { expect(page).to have_text("Deregistered") }

    within("#comment-history") do
      expect(page).to have_text("Deregistered exemption with Operator failings")
      expect(page).to have_text("#{user.email} - Deregistered by Alice!")
    end
  end

  scenario "unsuccessfully" do
    click_on "Deregister registration"

    expect(page).to have_css(".govuk-error-message", text: "Enter a comment")
  end
end
