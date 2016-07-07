# Simple service to shield Controller from actual read mechanism

class ReadEnrollmentExportReport

  def initialize(enrollment_export)
    @enrollment_export = enrollment_export
  end

  def self.run(enrollment_export)
    new(enrollment_export).call
  end

  def call
    if ENV["EXPORT_USE_FILESYSTEM_NOT_AWS_S3"]
      File.read(enrollment_export.full_path)
    else
      ReadFromAwsS3.run(enrollment_export)
    end
  end

  private

  attr_accessor :enrollment_export

end
