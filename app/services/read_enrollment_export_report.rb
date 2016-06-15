class ReadEnrollmentExportReport

  def initialize(enrollment_export)
    @enrollment_export = enrollment_export
  end

  def call
    presigned_url
  end

  private

  attr_accessor :enrollment_export

  def presigned_url
    # TOFIX - Replace with AWS
    File.read(enrollment_export.full_path)

    # TODO: - TOM STATTER - Need details of bucket from Imran Javeed
    #     s3 = Aws::S3::Resource.new
    #     bucket = s3.bucket ENV.fetch("AWS_MANUAL_EXPORT_BUCKET")
    #
    #     bucket.object(file_name).presigned_url(
    #       :get,
    #       expires_in: 20.minutes, secure: true,
    #       response_content_type: "text/csv",
    #       response_content_disposition: "attachment; filename=#{file_name}"
    #     )
  end

end
