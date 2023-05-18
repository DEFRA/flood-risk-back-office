# frozen_string_literal: true

class UserMailer < ApplicationMailer
  include Rails.application.routes.url_helpers
  include Rails.application.routes.mounted_helpers
  include Devise::Controllers::UrlHelpers

  default from: "no-reply@environment-agency.gov.uk"

  def invitation_instructions(record, token, _opts = {})
    @resource = record
    @email = record.email
    @token = token
    @link = accept_user_invitation_url(invitation_token: token)

    mail(
      to: @email,
      subject: I18n.t("devise.mailer.invitation_instructions.subject"),
      template_id: "d13b900d-5145-481c-947b-6776afad8ea0",
      personalisation: {
        account_email: @email,
        invite_link: @link
      }
    )
  end

  def reset_password_instructions(record, token, _opts = {})
    @resource = record
    @email = record.email
    @token = token
    @link = edit_user_password_url(reset_password_token: token)

    mail(
      to: record.email,
      subject: I18n.t("devise.mailer.reset_password_instructions.subject"),
      template_id: "3fc1ef2d-0fa4-4f87-a319-a3b6dee34cb8",
      personalisation: {
        account_email: @email,
        change_password_link: @link
      }
    )
  end

  def unlock_instructions(record, token, _opts = {})
    @resource = record
    @email = record.email
    @token = token
    @link = user_unlock_url(unlock_token: token)

    mail(
      to: record.email,
      subject: I18n.t("devise.mailer.unlock_instructions.subject"),
      template_id: "9a4763eb-e1e2-4f14-abda-da4629336d7e",
      personalisation: {
        account_email: @email,
        unlock_url: @link
      }
    )
  end
end
