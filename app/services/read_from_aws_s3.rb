class ReadFromAwsS3

  def initialize(enrollment_export)
    @enrollment_export = enrollment_export
  end

  def self.run(enrollment_export)
    new(enrollment_export).call
  end

  def call
    s3 = Aws::S3::Resource.new
    bucket = s3.bucket ENV.fetch("AWS_MANUAL_EXPORT_BUCKET")

    bucket.object(enrollment_export.file_name).presigned_url(
      :get,
      expires_in: 20.minutes, secure: true,
      response_content_type: "text/csv",
      response_content_disposition: "attachment; filename=#{enrollment_export.file_name}"
    )
  end

  private

  attr_accessor :enrollment_export

end
