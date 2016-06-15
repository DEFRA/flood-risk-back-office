require "csv"

class EnrollmentExport < ActiveRecord::Base

  enum state: {
    queued: 0,
    started: 1,
    failed: 2,
    completed: 3
  }

  def run
    report_data = PrepareEnrollmentExportReport.new(self)

    csv_data = report_data.call

    begin

      writer = WriteEnrollmentExportReport.new(self, csv_data)

      writer.call

      writer.completed
    rescue => ex
      writer.failed("#{ex.class}: #{ex}")
      raise
    end
  end

  def to_s
    from = I18n.l(from_date, format: :medium) if from_date
    to = I18n.l(to_date, format: :medium) if to_date

    [from, to].reject(&:blank?).join(" - ")
  end

  def date_for_filename(date)
    date.strftime("%Y%m%d")
  end

  def populate_file_name
    from = date_for_filename(from_date) if from_date
    to = date_for_filename(to_date) if to_date

    prefix = [from, to].reject(&:blank?).join("-")
    ext = "csv"
    count = 0

    self.file_name =
      loop do
        name = [prefix, (count == 0 ? "" : count.to_s), ext].reject(&:blank?).join(".")

        break name unless self.class.exists?(file_name: name)
        count += 1
      end
  end

  def full_path
    return nil unless file_name?

    Rails.root.join("private", "exports", file_name)
  end

  private

  def perform_s3_export!
    nil
    # TODO: - TOM STATTER - Needs investigation
    #     s3 = Aws::S3::Resource.new
    #     bucket = s3.bucket ENV.fetch("AWS_MANUAL_EXPORT_BUCKET")
    #     obj = bucket.object file_name
    #     obj.upload_file full_path
  end

end
