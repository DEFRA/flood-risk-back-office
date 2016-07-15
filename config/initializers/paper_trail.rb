PaperTrail.configure do |config|
  config.track_associations = true
end


require "paper_trail"

module FloodRiskEngine
  Enrollment.has_paper_trail          meta: { status: :step }
  EnrollmentExemption.has_paper_trail meta: { status: :status }
  Address.has_paper_trail
  Contact.has_paper_trail
  Location.has_paper_trail
  Organisation.has_paper_trail
  Partner.has_paper_trail
  ReferenceNumber.has_paper_trail     meta: { status: :number }
end

User.has_paper_trail
Role.has_paper_trail

FloodRiskEngine::Enrollments::StepsController.before_action :set_paper_trail_whodunnit
