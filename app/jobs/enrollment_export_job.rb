class EnrollmentExportJob < ActiveJob::Base
  queue_as :default

  def perform(enrollment_export)
    enrollment_export.run
  end
end
