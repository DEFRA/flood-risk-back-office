require "rails_helper"

RSpec.describe "In progress" do
  let(:enrollment_exemption) { create(:submitted_limited_company).enrollment_exemptions.first }
  let(:user) { create(:user) }

  before do
    enrollment_exemption.update(status: :pending)
    user.grant :system
    login_as user
    visit admin_enrollment_exemption_path(enrollment_exemption)

    within("#actions") { click_link("In progress") }
  end

  it "successfully" do
    click_on "Confirm In progress status"

    within("#status") { expect(page).to have_text("In progress") }
    within("#comment-history") { expect(page).to have_text("Status changed to In progress") }
    within("#comment-history") { expect(page).to have_text("#{user.email} - n/a") }
  end
end
