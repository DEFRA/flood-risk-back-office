class ReadFromAwsS3

  def initialize(enrollment_export)
    @enrollment_export = enrollment_export
  end

  def self.run(enrollment_export)
    new(enrollment_export).call
  end

  def call
    bucket = DefraRuby::Aws.get_bucket(bucket_name)

    DefraRuby::Aws::PresignedUrlService.run(bucket, enrollment_export.file_name)
  end

  private

  def bucket_name
    FloodRiskBackOffice::Application.config.enrollment_exports_bucket_name
  end

  attr_accessor :enrollment_export

end
