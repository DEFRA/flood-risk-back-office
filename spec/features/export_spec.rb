require "rails_helper"

RSpec.describe "enrollment exports" do

  describe "Export" do
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

    it "successfully creating an export" do
      expect(EnrollmentExportJob).to receive(:perform_later).once

      fill_in "enrollment_export_to_date_3i", with: 1
      fill_in "enrollment_export_to_date_2i", with: 10
      fill_in "enrollment_export_to_date_1i", with: 2020

      choose "Decision at"
      click_on "Create Export"

      expect(page).to have_text("Registration export [30 Sep 20 - 01 Oct 20]")

      expect(page).to have_css("tr.enrollment_export", text: user.email)
    end

    it "unsuccessfully creating an export" do
      fill_in "enrollment_export_to_date_3i", with: 29
      fill_in "enrollment_export_to_date_2i", with: 9
      fill_in "enrollment_export_to_date_1i", with: 2019

      click_on "Create Export"

      within(".govuk-error-message") do
        expect(page).to have_text("To date must be on or after the from date")
      end
    end
  end

  describe "GET enrollment_export" do
    let(:user) { create(:user) }
    let(:enrollment_export) { create(:enrollment_export, :with_dates, :with_file_name, :completed) }

    before do
      # avoid generating binary data for the purposes of this test
      allow_any_instance_of(Admin::EnrollmentExportsController).to receive(:send_data) # rubocop:disable RSpec/AnyInstance

      user.grant :system
      login_as user
      visit "/admin/enrollment_exports/#{enrollment_export.id}.csv"
    end

    it "returns HTTP 204 No Content" do
      expect(page.status_code).to eq 204
    end
  end
end
