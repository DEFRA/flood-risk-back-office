RSpec.describe "View Enrollment Exemption Detail" do
  before do
    user = create(:user)
    user.add_role :system
    login_as user
  end

  context "Enrollment NOT Submitted" do
    incomplete = FactoryBot.factories.collect(&:name).grep(/page/).tap do |a|
      a.delete :page_confirmation
    end

    enrollments = incomplete.collect do |f|
      FactoryBot.create(f)
    end

    enrollments.each do |enrollment|
      next unless enrollment.enrollment_exemptions.first

      it "does not display any actions when not sumbitted #{enrollment.step}" do
        enrollment_exemption = enrollment.enrollment_exemptions.first

        next unless enrollment_exemption

        enrollment_exemption.building!

        visit admin_enrollment_exemption_path(enrollment_exemption.id)

        expect(page).to have_css("#exemption-details")

        within "#actions" do
          expect(page).to have_no_link("Edit registration")
          expect(page).to have_no_link("Deregister")
          expect(page).to have_no_link("Reject")
          expect(page).to have_no_link("Approve")
          expect(page).to have_no_link("Withdraw")
        end
      end
    end
  end

  context "COMPLETE" do
    context "When Enrollment Submitted" do
      let(:enrollment) { create(:confirmed, submitted_at: Time.zone.now) }
      let(:enrollment_exemption) do
        enrollment.enrollment_exemptions.first.tap(&:pending!)
      end

      it "Page has the expected content - Status Pending" do
        visit admin_enrollment_exemption_path(enrollment_exemption)

        within "#registration-details" do
          expect(page).to have_css("td", text: enrollment.ref_number)
        end

        within "#correspondence-contact-details" do
          expect(page).to have_text(enrollment.correspondence_contact.full_name)
        end

        within "#secondary-contact-details" do
          expect(page).to have_text(enrollment.secondary_contact.email_address)
        end

        ee = enrollment.enrollment_exemptions.first

        within "#actions" do
          expect(page).to have_no_link(
            "Deregister", href: new_admin_enrollment_exemption_deregister_path(ee)
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
          expect(page).to have_link(
            "Withdraw",
            href: new_admin_enrollment_exemption_withdraw_path(
              enrollment.enrollment_exemptions.first
            )
          )
        end
      end

      context "Page has the expected content - Status APPROVED" do
        before do
          enrollment_exemption.approved!
          enrollment.reload
        end

        it "Page has the modified content" do
          visit admin_enrollment_exemption_path(enrollment_exemption)

          within "#actions" do
            expect(page).to have_link(
              "Deregister",
              href: new_admin_enrollment_exemption_deregister_path(enrollment_exemption)
            )

            expect(page).to have_no_link(
              "Reject",
              href: new_admin_enrollment_exemption_reject_path(enrollment_exemption)
            )

            expect(page).to have_no_link(
              "Approve",
              href: new_admin_enrollment_exemption_approve_path(
                enrollment.enrollment_exemptions.first
              )
            )

            expect(page).to have_no_link(
              "Withdraw",
              href: new_admin_enrollment_exemption_withdraw_path(
                enrollment.enrollment_exemptions.first
              )
            )
          end
        end
      end
    end

    context "without secondary contact" do
      let(:enrollment) { create(:confirmed_no_secondary_contact) }
      let(:enrollment_exemption) do
        create(
          :enrollment_exemption,
          enrollment:
        )
      end

      it "Page has the expected content when optional secondary_contact not present" do
        visit admin_enrollment_exemption_path(enrollment_exemption)

        within "#admin-enrollment-exemptions-show" do
          expect(page).to have_css("#correspondence-contact-details")
          expect(page).to have_no_css("#secondary-contact-details")
        end
      end
    end

    context "when organisation is partnership" do
      let(:enrollment) { create(:submitted_partnership) }

      it "Page has expected content for all partners" do
        visit admin_enrollment_exemption_path(enrollment.enrollment_exemptions.first)

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

    context "with organisation as limited company" do
      let(:enrollment) { create(:submitted_limited_company) }
      let(:organisation) { enrollment.organisation }
      let(:registration_number) { "WW123456" }

      before { organisation.update_attribute :registration_number, registration_number }

      it "Page has expected content for all partners" do
        visit admin_enrollment_exemption_path(enrollment.enrollment_exemptions.first)
        within "#registration-details" do
          expect(page).to have_text registration_number
        end
      end
    end
  end

  context "with comment history" do
    let(:enrollment) { create(:confirmed, submitted_at: Time.zone.now) }
    let(:user) { create(:user) }
    let(:comment) { create(:comment, user:) }
    let(:enrollment_exemption) do
      create(
        :enrollment_exemption,
        enrollment:,
        comments: [comment]
      )
    end

    it "Page has comment content" do
      visit admin_enrollment_exemption_path(enrollment_exemption)

      within "#comment-history" do
        expect(page).to have_text comment.event
      end
    end

    context "unless accessed by user without sufficent rights" do
      let(:non_system_user) { create(:user) }

      it "Page has the no comment content" do
        login_as non_system_user
        visit admin_enrollment_exemption_path(enrollment_exemption)
        expect(page).to have_no_css("#comment-history")
      end
    end
  end
end
