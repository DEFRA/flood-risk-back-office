#  As an NCCC System user, I want to be able to invite users
RSpec.describe "Invite user" do
  let(:email_addr) { "one@example.com" }

  before do
    User.where(email: email_addr).destroy_all
  end

  context "unauthorised" do
    it "Logged out user is asked to sign-in" do
      # don't sign in
      visit new_user_invitation_path
      expect(page).to have_current_path new_user_session_path, ignore_query: true
      expect(page).to have_flash(I18n.t("devise.failure.unauthenticated"), key: :alert)
    end

    it "User without role is denied access" do
      login_as create(:user)
      visit new_user_invitation_path

      expect(page).to have_current_path main_app.root_path, ignore_query: true
      expect(page).to have_flash(I18n.t("pundit.user_policy.invite?"), key: :alert)
    end

    %i[super_agent admin_agent data_agent].each do |role|
      it "#{role.to_s.humanize} user is denied access" do
        user = create(:user)
        user.add_role role
        login_as user
        visit new_user_invitation_path

        expect(page).to have_current_path main_app.root_path, ignore_query: true
        expect(page).to have_flash(I18n.t("pundit.user_policy.invite?"), key: :alert)
      end
    end
  end

  context "authorised" do
    before do
      user = create(:user)
      user.add_role :system
      login_as user
      visit new_user_invitation_path

      within "select#user-assigned-role-field" do
        expect(page).to have_css("option[value=system]", text: "System user")
        expect(page).to have_css("option[value=super_agent]", text: "Administrative super user")
        expect(page).to have_css("option[value=admin_agent]", text: "Administrative user")
        expect(page).to have_css("option[value=data_agent]", text: "Data user")
      end
    end

    context "invalid" do
      it "Invite user (invalid - existing email)" do
        create(:user, email: email_addr)
        fill_in "Email", with: email_addr
        select "System user", from: "Role"

        expect do
          click_button "Send an invitation"
        end.not_to change(User, :count)

        expect(page).to have_css(".govuk-error-message", text: "Email address has already been taken")
      end

      it "Invite a user who has already been invited - doesn't add a new user or role" do
        user = User.invite!(email: email_addr)
        user.add_role :data_agent

        fill_in "Email", with: email_addr
        select "System user", from: "Role"

        expect do
          click_button "Send an invitation"
        end.not_to change(User, :count)

        expect(user.roles.map(&:name)).to eq(["data_agent"])
      end

      it "Invite user (no role selected)" do
        fill_in "Email", with: email_addr

        expect do
          click_button "Send an invitation"
        end.not_to change(User, :count)

        expect(page).to have_css(".govuk-error-message", text: "You must select a user role")
      end
    end

    context "valid" do
      after do
        u = User.last
        expect(u.email).to eq email_addr

        expect(u.encrypted_password).to be_present # random password is set
        expect(u.invitation_token).to be_present
        expect(u.invitation_sent_at).to be_present

        expect(page).to have_flash I18n.t("devise.invitations.send_instructions", email: email_addr)

        logout :user

        expect(mailbox_for(email_addr)).to be_one
        email = open_last_email_for email_addr
        expect(email.subject).to eq I18n.t("devise.mailer.invitation_instructions.subject")
        expect(email).to have_body_text I18n.t("devise.mailer.invitation_instructions.hello", email: email_addr)
        expect(email).to have_body_text "You have been invited"
        visit_in_email I18n.t("devise.mailer.invitation_instructions.accept")

        new_password = "Abc123456"

        fill_in "New password", with: new_password, match: :first
        fill_in "Confirm new password", with: new_password

        click_button I18n.t("devise.invitations.edit.submit_button")

        expect(page).to have_current_path new_user_session_path, ignore_query: true
        expect(page).to have_css "h1", text: "Sign in"

        u.reload
        expect(u.encrypted_password).to be_present
        expect(u.encrypted_password).not_to eq new_password
        expect(u.valid_password?(new_password)).to be true
        expect(u.valid_password?(u.encrypted_password)).to be false
        expect(u.invitation_token).to be_blank
        expect(u.invitation_accepted_at).to be_present
      end

      it "Invite System user" do
        fill_in "Email", with: email_addr
        select "System user", from: "Role"

        expect do
          click_button "Send an invitation"
        end.to change(User, :count).by(1)

        u = User.last
        expect(u.roles.map(&:name)).to include "system"
        expect(u).to have_role :system
      end

      it "Invite Admin-agent user" do
        fill_in "Email", with: email_addr
        select "Administrative user", from: "Role"

        expect do
          click_button "Send an invitation"
        end.to change(User, :count).by(1)

        u = User.last
        expect(u.roles.map(&:name)).to include "admin_agent"
        expect(u).to have_role :admin_agent
      end

    end
  end
end
