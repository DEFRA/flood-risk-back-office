require "csv"

class EnrollmentExport < ActiveRecord::Base

  enum state: {
    queued: 0,
    started: 1,
    failed: 2,
    completed: 3
  }

  enum date_field_scope: {
    submitted_at: 0,
    decision_at: 1
  }

  def reportable_records
    find_klazz = FloodRiskEngine::EnrollmentExemption

    case date_field_scope
      when "submitted_at"
        find_klazz.reportable_by_submitted_at(from_date, to_date)
      when "decision_at"
        find_klazz.reportable_by_decision_at(from_date, to_date)
      else
        find_klazz.reportable_by_submitted_at(from_date, to_date)
    end
  end

  def csv_data
    PrepareEnrollmentExportReport.run(self)
  end

  def writer
    @writer ||= WriteEnrollmentExportReport.new(self, csv_data)
  end

  def run
    writer.call

    WriteToAwsS3.run(self) unless ENV["EXPORT_USE_FILESYSTEM_NOT_AWS_S3"]

    writer.complete!
  rescue => ex
    writer.failed("#{ex.class}: #{ex}")
    raise
  end

  def to_s
    from = I18n.l(from_date, format: :medium) if from_date
    to = I18n.l(to_date, format: :medium) if to_date

    [from, to].reject(&:blank?).join(" - ")
  end

  def date_for_filename(date)
    return unless date
    date.strftime("%Y%m%d")
  end

  def populate_file_name
    from = date_for_filename(from_date)
    to = date_for_filename(to_date)

    prefix = [date_field_scope, from, to].reject(&:blank?).join("-")
    count = 0

    self.file_name =
      loop do
        name = [prefix, (count == 0 ? "" : count.to_s), "csv"].reject(&:blank?).join(".")

        break name unless self.class.exists?(file_name: name)
        count += 1
      end
  end

  def full_path
    return nil unless file_name?

    Rails.root.join("private", "exports", file_name)
  end

end
