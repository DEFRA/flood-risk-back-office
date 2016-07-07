RSpec.feature "View Enrollment Exemption Detail" do
  background do
    user = create :user
    user.add_role :system
    login_as user
  end

  context("with secondary contact ") do
    let(:enrollment) { create :confirmed, submitted_at: Time.zone.now }
    let(:enrollment_exemption) do
      enrollment.enrollment_exemptions.first.tap(&:pending!)
    end

    scenario "Page has the expected content" do
      visit admin_enrollment_exemption_path(enrollment_exemption)

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
        expect(page).not_to have_link(
          "Deregister",
          href: new_admin_enrollment_exemption_deregister_path(
            enrollment.enrollment_exemptions.first
          )
        )
        expect(page).to have_link(
          "Reject",
          href: new_admin_enrollment_exemption_reject_path(
            enrollment.enrollment_exemptions.first
          )
        )
        expect(page).to have_link(
          "Approve",
          href: new_admin_enrollment_exemption_approve_path(
            enrollment.enrollment_exemptions.first
          )
        )
        expect(page).to have_css("#change-assisted-digital")
      end
    end

    context("when the enrollment exemption is approved") do
      before do
        enrollment_exemption.approved!
        enrollment.reload
      end

      scenario "Page has the modified content" do
        visit admin_enrollment_exemption_path(enrollment_exemption)

        within ".panel.actions" do
          expect(page).to have_link(
            "Deregister",
            href: new_admin_enrollment_exemption_deregister_path(enrollment_exemption)
          )

          expect(page).not_to have_link(
            "Reject",
            href: new_admin_enrollment_exemption_reject_path(enrollment_exemption)
          )
          expect(page).not_to have_link(
            "Approve",
            href: new_admin_enrollment_exemption_approve_path(
              enrollment.enrollment_exemptions.first
            )
          )
        end
      end
    end
  end

  context("without secondary contact ") do
    let(:enrollment) { create :confirmed_no_secondary_contact }
    let(:enrollment_exemption) do
      create(
        :enrollment_exemption,
        enrollment: enrollment
      )
    end

    scenario "Page has the expected content when optional secondary_contact not present" do
      visit admin_enrollment_exemption_path(enrollment_exemption)

      within "#admin-enrollment-exemptions-show" do
        expect(page).to have_css("#correspondence-contact-details")
        expect(page).to_not have_css("#secondary-contact-details")
      end
    end
  end

  context("when organisation is partnership") do
    let(:enrollment) { create :submitted_partnership }

    scenario "Page has expected content for all partners", duff: true do
      visit admin_enrollment_exemption_path(enrollment.enrollment_exemptions.first.id)

      within "#admin-enrollment-exemptions-show" do
        expect(enrollment.organisation.partners.size).to be > 0

        # factory generates a random number of partners  -  they should all be represented
        enrollment.organisation.partners.each_with_index do |p, i|
          expect(page).to have_text p.full_name
          expect(page).to have_text "Partner #{i + 1}"
        end
      end
    end
  end
end
