class ReadFromAwsS3

  def initialize(enrollment_export)
    @enrollment_export = enrollment_export
  end

  def self.run(enrollment_export)
    new(enrollment_export).call
  end

  def call
    secrets = Rails.application.secrets
    s3 = Aws::S3::Resource.new(
      region: secrets.aws_region,
      credentials: Aws::Credentials.new(secrets.aws_access_key_id, secrets.aws_secret_access_key)
    )
    bucket = s3.bucket ENV.fetch("FRA_AWS_MANUAL_EXPORT_BUCKET")

    bucket.object(enrollment_export.file_name).presigned_url(
      :get,
      expires_in: 20 * 60, # 20 minutes in seconds
      secure: true,
      response_content_type: "text/csv",
      response_content_disposition: "attachment; filename=#{enrollment_export.file_name}"
    )
  end

  private

  attr_accessor :enrollment_export

end
