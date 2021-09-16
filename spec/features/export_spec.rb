require "rails_helper"

RSpec.describe "Export" do
  let(:user) { create(:user) }
  let(:from_date) { Date.new(2020, 12, 11) }
  let(:to_date) { Date.new(2020, 12, 12) }

  before do
    user.grant :system
    login_as user
    visit "/"
    within("#navigation") { click_link "Export" }

    fill_in "enrollment_export_from_date_3i", with: 30
    fill_in "enrollment_export_from_date_2i", with: 9
    fill_in "enrollment_export_from_date_1i", with: 2020
  end

  scenario "successfully creating an export" do

    fill_in "enrollment_export_to_date_3i", with: 1
    fill_in "enrollment_export_to_date_2i", with: 10
    fill_in "enrollment_export_to_date_1i", with: 2020

    choose "Decision at"
    click_on "Create Export"

    expect(page).to have_text("Registration export [30 Sep 20 - 01 Oct 20]")

    expect(page).to have_css("tr.enrollment_export", text: user.email)
  end

  scenario "unsuccessfully creating an export" do
    fill_in "enrollment_export_to_date_3i", with: 29
    fill_in "enrollment_export_to_date_2i", with: 9
    fill_in "enrollment_export_to_date_1i", with: 2019

    click_on "Create Export"

    within(".govuk-error-message") do
      expect(page).to have_text("To date must be on or after the from date")
    end
  end
end
