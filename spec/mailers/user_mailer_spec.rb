# frozen_string_literal: true

require "rails_helper"

RSpec.describe UserMailer do
  let(:token) { "abcde12345" }
  let(:user) do
    instance_double(
      User,
      email: "grace.hopper@example.com",
      raw_invitation_token: token,
      role_names: "admin_agent"
    )
  end

  describe "invitation_instructions" do
    it "sets the correct properties" do
      mail = described_class.invitation_instructions(user, token)

      expect(mail.to).to eq([user.email])
      expect(mail.subject).to eq(I18n.t("devise.mailer.invitation_instructions.subject"))
      expect(mail[:template_id].to_s).to eq("d13b900d-5145-481c-947b-6776afad8ea0")
      expect(mail[:personalisation].unparsed_value).to have_key(:account_email)
      expect(mail[:personalisation].unparsed_value[:account_email]).to eq("grace.hopper@example.com")
      expect(mail[:personalisation].unparsed_value).to have_key(:invite_link)
      expect(mail[:personalisation].unparsed_value[:invite_link]).to \
        include("/users/invitation/accept?invitation_token=abcde12345")
    end
  end

  describe "reset_password_instructions" do
    it "sets the correct properties" do
      mail = described_class.reset_password_instructions(user, token)

      expect(mail.to).to eq([user.email])
      expect(mail.subject).to eq(I18n.t("devise.mailer.reset_password_instructions.subject"))
      expect(mail[:template_id].to_s).to eq("3fc1ef2d-0fa4-4f87-a319-a3b6dee34cb8")
      expect(mail[:personalisation].unparsed_value).to have_key(:account_email)
      expect(mail[:personalisation].unparsed_value[:account_email]).to eq("grace.hopper@example.com")
      expect(mail[:personalisation].unparsed_value).to have_key(:change_password_link)
      expect(mail[:personalisation].unparsed_value[:change_password_link]).to \
        include("/users/password/edit?reset_password_token=abcde12345")
    end
  end

  describe "unlock_instructions" do
    it "sets the correct properties" do
      mail = described_class.unlock_instructions(user, token)

      expect(mail.to).to eq([user.email])
      expect(mail.subject).to eq(I18n.t("devise.mailer.unlock_instructions.subject"))
      expect(mail[:template_id].to_s).to eq("9a4763eb-e1e2-4f14-abda-da4629336d7e")
      expect(mail[:personalisation].unparsed_value).to have_key(:account_email)
      expect(mail[:personalisation].unparsed_value[:account_email]).to eq("grace.hopper@example.com")
      expect(mail[:personalisation].unparsed_value).to have_key(:unlock_url)
      expect(mail[:personalisation].unparsed_value[:unlock_url]).to include("/users/unlock?unlock_token=abcde12345")
    end
  end
end
