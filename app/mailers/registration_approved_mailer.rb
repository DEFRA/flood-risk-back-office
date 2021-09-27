class RegistrationApprovedMailer < ActionMailer::Base

  helper(FloodRiskEngine::EmailHelper)

  layout "layouts/backend_mail"

  def approved(enrollment_exemption:, recipient_address:)
    i18n_scope = RegistrationApprovedMailer.mail_yaml_key
    subject = I18n.t(".subject", scope: i18n_scope)

    @presenter = ExemptionEmailPresenter.new(enrollment_exemption)

    mail to: recipient_address, from: ENV["DEVISE_MAILER_SENDER"], subject: subject
  end

  def self.mail_yaml_key
    "admin.registration_approved_mailer.approved"
  end
end
