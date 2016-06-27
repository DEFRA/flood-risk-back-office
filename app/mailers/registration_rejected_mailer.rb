class RegistrationRejectedMailer < ActionMailer::Base

  add_template_helper(FloodRiskEngine::EmailHelper)

  layout "layouts/backend_mail"

  def rejected(enrollment_id:, recipient_address:)
    i18n_scope = RegistrationRejectedMailer.mail_yaml_key
    subject = I18n.t(".subject", scope: i18n_scope)
    underlying_enrollment = FloodRiskEngine::Enrollment.find(enrollment_id)

    @presenter = EmailPresenter.new(underlying_enrollment)

    mail to: recipient_address, from: ENV["DEVISE_MAILER_SENDER"], subject: subject
  end

  def self.mail_yaml_key
    "admin.registration_rejected_mailer.rejected"
  end
end
