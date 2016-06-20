RSpec.feature "View Enrollment Exemption Detail" do
  background do
    user = create :user
    user.add_role :system
    login_as user
  end

  context("with secondary contact ") do
    let(:enrollment) { create :confirmed }

    scenario "Page has the expected content" do
      visit admin_enrollment_exemption_path(enrollment.id)

      within "#registration-details" do
        expect(page).to have_css("td", text: enrollment.reference_number)
      end

      within "#correspondence-contact-details" do
        expect(page).to have_css("strong", text: enrollment.correspondence_contact.full_name)
      end

      within "#secondary-contact-details" do
        expect(page).to have_css("strong", text: enrollment.secondary_contact.full_name)
      end

      within ".panel.actions" do
        expect(page).to have_css("#update-enrollment-exemption-status")
      end

      within ".panel.actions" do
        expect(page).to have_css("#change-assisted-digital")
      end
    end
  end

  context("without secondary contact ") do
    let(:enrollment) { create :confirmed_no_secondary_contact }

    scenario "Page has the expected content when optional secondary_contact not present" do
      visit admin_enrollment_exemption_path(enrollment.id)

      within "#admin-enrollment-exemptions-show" do
        expect(page).to have_css("#correspondence-contact-details")
        expect(page).to_not have_css("#secondary-contact-details")
      end
    end
  end
end
