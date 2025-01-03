require "csv"

class EnrollmentExport < ActiveRecord::Base

  enum :state, {
    queued: 0,
    started: 1,
    failed: 2,
    completed: 3
  }

  enum :date_field_scope, {
    submitted_at: 0,
    decision_at: 1
  }

  validate :from_date_on_or_before,
           :to_date_on_or_before,
           :to_date_on_or_after

  validates :from_date,
            :to_date,
            :created_by,
            :date_field_scope,
            presence: true

  def reportable_records
    FloodRiskEngine::EnrollmentExemption.send("reportable_by_#{date_field_scope}", from_date, to_date)
  end

  def csv_data
    PrepareEnrollmentExportReport.run(self)
  end

  def writer
    @writer ||= WriteEnrollmentExportReport.new(self)
  end

  def run
    writer.run(csv_data)

    WriteToAwsS3.run(self) unless ENV["EXPORT_USE_FILESYSTEM_NOT_AWS_S3"]

    writer.complete!
  rescue StandardError => e
    writer.failed("#{e.class}: #{e}")
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
        name = [prefix, (count.zero? ? "" : count.to_s), "csv"].reject(&:blank?).join(".")

        break name unless self.class.exists?(file_name: name)

        count += 1
      end
  end

  def full_path
    return nil unless file_name?

    Rails.root.join("private", "exports", file_name)
  end

  private

  def from_date_on_or_before
    return unless from_date

    errors.add(:from_date, :on_or_before) unless from_date <= Date.today
  end

  def to_date_on_or_before
    return unless to_date

    errors.add(:to_date, :on_or_before) unless to_date <= Date.today
  end

  def to_date_on_or_after
    return unless from_date && to_date

    errors.add(:to_date, :on_or_after) unless to_date >= from_date
  end
end
