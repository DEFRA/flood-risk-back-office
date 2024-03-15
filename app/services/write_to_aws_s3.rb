class WriteToAwsS3
  include CanLoadFileToAws

  def initialize(enrollment_export)
    @enrollment_export = enrollment_export
  end

  def self.run(enrollment_export)
    new(enrollment_export).call
  end

  def call
    load_file_to_aws_bucket({ server_side_encryption: "aws:kms" })
  end

  private

  attr_accessor :enrollment_export

  def file_path
    enrollment_export.full_path
  end

  def bucket_name
    FloodRiskBackOffice::Application.config.enrollment_exports_bucket_name
  end
end
