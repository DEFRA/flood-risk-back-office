class SendRegistrationApprovedEmail

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
      Notify::RegistrationApprovedEmailService.run(
        enrollment:,
        recipient_address: recipient
      )
    end
  end

  private

  attr_reader :enrollment_exemption

  delegate :enrollment, to: :enrollment_exemption

  def validate_enrollment
    raise(ArgumentError, "Enrollment Exemption argument not supplied") unless enrollment_exemption.present?

    unless enrollment_exemption.approved?
      raise FloodRiskEngine::InvalidEnrollmentStateError, "Exemption not in approved state"
    end

    raise FloodRiskEngine::MissingEmailAddressError, "Missing contact email address" if primary_contact_email.blank?
  end

end
