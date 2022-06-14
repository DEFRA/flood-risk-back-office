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
      Notify::RegistrationRejectedEmailService.run(
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

    unless enrollment_exemption.rejected?
      raise(
        FloodRiskEngine::InvalidEnrollmentStateError,
        "Exemption not in rejected state"
      )
    end

    return unless primary_contact_email.blank?

    raise(
      FloodRiskEngine::MissingEmailAddressError,
      "Missing contact email address"
    )
  end

end
