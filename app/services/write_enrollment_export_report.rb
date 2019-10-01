class WriteEnrollmentExportReport

  def initialize(enrollment_export)
    @enrollment_export = enrollment_export
  end

  def column_names
    PrepareEnrollmentExportReport.column_names
  end

  def started
    enrollment_export.update!(state: :started)
  end

  def complete!
    enrollment_export.update!(state: :completed)
  end

  def failed(message)
    enrollment_export.update!(state: :failed, failure_text: message)
  end

  def run(csv_data)
    started

    @csv_data = csv_data

    CSV.open(enrollment_export.full_path, "wb", force_quotes: true) do |csv|
      csv << column_names
      csv.flush

      csv_data.each { |batch| csv << batch }

      csv.flush
    end
  end

  private

  attr_accessor :csv_data
  attr_accessor :enrollment_export

end
