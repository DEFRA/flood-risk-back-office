class SendRegistrationRejectedEmail

  include Admin::CommonMailer

  def initialize(enrollment)
    @enrollment = enrollment
  end

  def call
    validate_enrollment
    distinct_recipients.each do |recipient|
      mailer = RegistrationRejectedMailer.rejected(enrollment_id: enrollment.id, recipient_address: recipient)
      mailer.deliver_later
    end
  end

  private

  attr_reader :enrollment

  def validate_enrollment
    raise ArgumentError, "Enrollment argument not supplied" unless enrollment.present?
    # TODO: is this the enrollment status or the enrollment_exemption sttus that is rejected?
    raise FloodRiskEngine::InvalidEnrollmentStateError, "Enrollment not in rejected state" unless enrollment.rejected?
    raise FloodRiskEngine::MissingEmailAddressError, "Missing contact email address" if primary_contact_email.blank?
  end

end
