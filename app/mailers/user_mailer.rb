# frozen_string_literal: true

##
# Handles all emails related to user accounts
#
# We tell [Devise](https://github.com/heartcombo/devise) to use this instead of
# [its own](https://github.com/heartcombo/devise/blob/main/app/mailers/devise/mailer.rb) in the
# `config/initializers/devise.rb`.
#
#   config.mailer = "UserMailer"
#
# Then where we are using Devise to handle a user function instead of calling its own mailer it will use ours instead.
# That is as long as we have implemented a method with the same name and signature.
#
# Of those the original team opted to use their own invitiation mail view and mailer. But they did use Devise for the
# forgotten password reset and unlock account functions.
#
# In all cases we need to add additional information to the object we pass through to `mail()` in order to get the
# information to `NotifyMail`. It will then use the template ID and personalisation when calling the Notify web API.
class UserMailer < ApplicationMailer
  # When you generate Devise mailer views they will use Devise URL helpers. They differ in that they seem to generate
  # generic links rather than `user` specific. For example, the Rails `edit_user_password_url` will generate
  #
  # http://localhost:3001/auth/password/edit.10?reset_password_token=ncnfuszTvXMpAp_8gDBs
  #
  # The Devise `edit_password_url` will generate
  #
  # http://localhost:3001/auth/password/edit?reset_password_token=z8kHQ8eRx4SQ48kzkZpw
  #
  # It's a slight difference but it ensures we don't give away the user ID in the link. If you read the comments in
  # Devise::Controllers::UrlHelpers it states
  #
  # > In case you want to add such helpers to another class, you can do that as long as this new class includes both
  # > url_helpers and mounted_helpers.
  #
  # Thanks to https://stackoverflow.com/a/29887730/6117745 for giving us the clue which led to use getting
  # `edit_password_url()` working.
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
