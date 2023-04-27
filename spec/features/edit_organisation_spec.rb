require "rails_helper"

RSpec.describe "Edit organisation" do
  let(:enrollment_exemption) { create(:submitted_limited_company).enrollment_exemptions.first }
  let(:user) { create(:user) }

  before do
    user.grant :system
    login_as user
    visit admin_enrollment_exemption_path(enrollment_exemption)

    within("#operator-name") { click_link("Edit") }
  end

  it "successfully" do
    fill_in "Operator name", with: "Alice Apple"
    click_on "Continue"

    within("#operator-name") do
      expect(page).to have_text("Alice Apple")
    end
  end

  it "unsuccessfully" do
    fill_in "Operator name", with: ""
    click_on "Continue"

    expect(page).to have_css(".govuk-error-message", text: "Enter an operator name")
  end
end
