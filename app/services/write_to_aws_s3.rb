class WriteToAwsS3

  def initialize(enrollment_export)
    @enrollment_export = enrollment_export
  end

  def self.run(enrollment_export)
    new(enrollment_export).call
  end

  def call
    s3 = begin
           Aws::S3::Resource.new
         rescue StandardError => e
           Rails.logger.error(e.backtrace.first.inspect)
           Rails.logger.error("AWS setup failed - check you initializer and config : #{e.inspect}")
           raise e
         end

    bucket = s3.bucket ENV.fetch("AWS_MANUAL_EXPORT_BUCKET")
    obj = bucket.object enrollment_export.file_name
    obj.upload_file(enrollment_export.full_path)
  end

  private

  attr_accessor :enrollment_export

end
