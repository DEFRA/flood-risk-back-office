class WriteToAwsS3

  def initialize(enrollment_export)
    @enrollment_export = enrollment_export
  end

  def self.run(enrollment_export)
    new(enrollment_export).call
  end

  def call
    bucket = s3.bucket ENV.fetch("FRA_AWS_MANUAL_EXPORT_BUCKET")
    obj = bucket.object enrollment_export.file_name
    obj.upload_file(
      enrollment_export.full_path,
      server_side_encryption: "aws:kms"
    )
  end

  private

  attr_accessor :enrollment_export

  def s3
    secrets = Rails.application.secrets
    Aws::S3::Resource.new(
      region: secrets.aws_region,
      credentials: Aws::Credentials.new(secrets.aws_access_key_id, secrets.aws_secret_access_key)
    )
  rescue StandardError => e
    Rails.logger.error(e.backtrace.first.inspect)
    Rails.logger.error("AWS setup failed - check you initializer and config : #{e.inspect}")
    raise e
  end
end
