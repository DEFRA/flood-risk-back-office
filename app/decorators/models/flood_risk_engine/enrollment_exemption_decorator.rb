FloodRiskEngine::EnrollmentExemption.class_eval do
  # TODO: - Is valid_from the Correct DATE FIELD - suspect there could be others once the NCCC workflow complete
  # such as completed_at, submitted_at or registered_at

  # rubocop:disable Style/Lambda
  scope :reportable_by_date, ->(start_date, end_date) {
    where("date(valid_from) >= ? AND date(valid_from) <= ?", start_date, end_date)
  }

  scope :reportable_status, -> { where(status: FloodRiskEngine::EnrollmentExemption.statuses[:approved]) }

  # Usage for an Export :
  #   EnrollmentExemption.reportable(enrollment_export.from_date, enrollment_export.to_date)
  #
  class << self
    def reportable(from_date, to_date)
      reportable_by_date(from_date, to_date)
        .includes(enrollment: [:exemptions, :organisation, :correspondence_contact, :exemption_location])
    end
  end
end
