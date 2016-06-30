class SendRegistrationRejectedEmail

  include Admin::CommonMailer

  def self.for(enrollment_exemption)
    new(enrollment_exemption).call
  end

  def initialize(enrollment_exemption)
    @enrollment_exemption = enrollment_exemption
  end

  def call
    validate_enrollment
    distinct_recipients.each do |recipient|
      mailer = RegistrationRejectedMailer.rejected(
        enrollment_exemption: enrollment_exemption,
        recipient_address: recipient
      )
      mailer.deliver_later
    end
  end

  private

  attr_reader :enrollment_exemption
  delegate :enrollment, to: :enrollment_exemption

  def validate_enrollment
    raise(
      ArgumentError,
      "enrollment_exemption argument not supplied"
    ) unless enrollment_exemption.present?

    raise(
      FloodRiskEngine::InvalidEnrollmentStateError,
      "Enrollment not in rejected state"
    ) unless enrollment_exemption.rejected?

    raise(
      FloodRiskEngine::MissingEmailAddressError,
      "Missing contact email address"
    ) if primary_contact_email.blank?
  end

end
