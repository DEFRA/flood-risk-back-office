FloodRiskEngine::EnrollmentExemption.class_eval do
  has_paper_trail meta: { status: :status }

  belongs_to :accept_reject_decision_user, class_name: "User"

  # rubocop:disable Style/Lambda

  scope :by_submitted_at, ->(start_date, end_date) {
    includes(:enrollment).where(
      flood_risk_engine_enrollments: { submitted_at: start_date.beginning_of_day..end_date.end_of_day }
    )
  }

  scope :by_decision_at, ->(start_date, end_date) {
    where(accept_reject_decision_at: start_date.beginning_of_day..end_date.end_of_day)
  }

  scope :reportable_status, -> { where(status: FloodRiskEngine::EnrollmentExemption.statuses[:approved]) }

  # Usage for an Export :
  #   EnrollmentExemption.reportable_by_submitted_at(enrollment_export.from_date, enrollment_export.to_date)
  #
  class << self
    def reportable_by_submitted_at(from_date, to_date)
      by_submitted_at(from_date, to_date)
        .includes(:comments, enrollment: [:exemptions, :organisation, :correspondence_contact, :exemption_location])
    end

    def reportable_by_decision_at(from_date, to_date)
      by_decision_at(from_date, to_date)
        .includes(:comments, enrollment: [:exemptions, :organisation, :correspondence_contact, :exemption_location])
    end

  end
end
