RSpec.feature "Change enrollment's assistance mode" do

  let(:user) {  create(:user).tap { |u| u.add_role :system } }

  let(:scope) { Admin::EnrollmentExemptions::AssistanceForm.locale_key }

  let(:enrollment) { create :confirmed }
  let(:enrollment_exemption) {  enrollment.enrollment_exemptions.first }

  let(:comment) { Faker::Lorem.paragraph }

  let(:actions_panel_css) { "#actions" }
  let(:select_box_css)    { "admin_enrollment_exemptions_assistance_assistance_mode" }
  let(:comment_box_css)   { "admin_enrollment_exemptions_assistance_comment" }

  before(:each) do
    login_as user

    visit admin_enrollment_exemption_path(enrollment_exemption)

    within actions_panel_css do
      click_link I18n.t("admin.enrollment_exemptions.show.actions.change_ad")
    end

    expect(page.current_path).to eq(edit_admin_enrollment_exemption_assistance_path(enrollment_exemption))
  end

  scenario "The form displays previously set AD classification" do

    mode_text = EnrollmentExemptionPresenter.assistance_mode_text enrollment_exemption.assistance_mode

    expect(page).to have_css("h1:first", text: I18n.t(".edit.title", scope: scope))
    expect(page).to have_select("admin_enrollment_exemptions_assistance_assistance_mode", selected: mode_text)
  end

  EnrollmentExemptionPresenter.assistance_modes_map.each do |mode_text, mode_name|
    scenario "Change enrollment mode to '#{mode_text}'" do

      expect(page).to have_css("h1:first", text: I18n.t(".edit.title", scope: scope))

      select mode_text, from: select_box_css
      fill_in comment_box_css, with: comment

      click_button I18n.t("edit.submit", scope: scope)

      expect(page.current_path).to eq(admin_enrollment_exemption_path(enrollment_exemption))

      enrollment_exemption.reload

      expect(enrollment_exemption.assistance_mode).to eq mode_name

      display_mode = EnrollmentExemptionPresenter.assistance_mode_text(enrollment_exemption.assistance_mode)

     # redirect_to [:admin, enrollment_exemption], notice: t(".notice", mode: display_mode)

      msg = I18n.t(".update.notice", scope: scope, mode: display_mode)

      expect(page).to have_flash msg
      expect(FloodRiskEngine::Comment.last.content).to eq(comment)
      expect(FloodRiskEngine::Comment.last.user).to eq(user)
    end
  end
end
