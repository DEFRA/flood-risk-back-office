require "paper_trail"

# these classses are required on boot, so have to be loaded explicitly (since Rails 7 - zeitwerk autoloader)
require "user"
require "role"

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
