FloodRiskEngine::Enrollment.class_eval do
  # rubocop:disable Style/Lambda
  scope :reportable, ->(start_date, end_date) {
    where("date(updated_at) >= ? AND date(updated_at) <= ?", start_date, end_date)
  }

  scope :reportable_status, -> { where(status: FloodRiskEngine::Enrollment.statuses[:approved]) }
end
