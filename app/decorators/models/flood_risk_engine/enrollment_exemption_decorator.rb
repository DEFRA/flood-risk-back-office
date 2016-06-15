FloodRiskEngine::EnrollmentExemption.class_eval do
  # TODO: -Putting status here for now for RIP-212 so it can be easily MOVED once Engine
  # updated with related stories concerning NCCC management of EnrollmentExemption

  enum status: {
    building: 0,        # FO: anywhere before the confirmation step
    pending: 1,         # FO: enrollment submitted and awaiting BO processing
    being_processed: 2, # BO: prevents another admin user from processing it
    approved: 3,        # BO: all checks pass
    rejected: 4,        # BO: because e.g. grid ref in an SSI
    expired: 5,         # BO: FRA23/24 only - expiry date has passed
    withdrawn: 6        # BO: used to hide anything created in error
  }

  # TODO: - Is this thr Correct DATE FIELD - valid_from: suspect there could be others once the NCCC workflow complete
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
      reportable_status
        .includes(enrollment: [:exemptions, :organisation, :correspondence_contact, :exemption_location])
        .reportable_by_date(from_date, to_date)
    end
  end
end
