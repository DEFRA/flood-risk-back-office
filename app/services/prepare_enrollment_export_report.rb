class PrepareEnrollmentExportReport

  attr_reader :csv_data

  def initialize(enrollment_export)
    @enrollment_export = enrollment_export

    @csv_data = []
  end

  def call
    @records = reportable_records

    enrollment_export.update!(record_count: records.size) if records

    csv_data = records.collect { |record| generate_row(record) }

    Rails.logger.info("** Example Record **\n\t #{csv_data.last.inspect}")

    csv_data
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def generate_row(record)
    enrollment = record.enrollment

    [
      record.status,
      "TBD Submitted date",
      "TBD Decision date",
      "TBD Decision maker",
      enrollment_export.created_by,
      # TODO: - Using '' so Excel treats it as string not number - can prob remove once proper stringified Ref in place
      "'#{enrollment.reference_number}'",
      enrollment.exemption_location.grid_reference,
      enrollment.exemption_location.description,
      "TBD EA Area",
      enrollment.exemptions.first.code,
      enrollment.organisation.org_type,
      enrollment.correspondence_contact.full_name,
      enrollment.correspondence_contact.email_address,
      enrollment.correspondence_contact.telephone_number,
      enrollment.organisation.name,
      "#{url_prefix}/#{enrollment.id}"
    ]
  rescue => x
    Rails.logger.error("Failed to report on Enrollment #{enrollment.id} (#{enrollment.reference_number})")
    Rails.logger.error(x.inspect)
    []
  end

  def self.column_names
    [
      "Registration status",
      "Submitted date",
      "Decision date",
      "Decision maker",
      "Created by",
      "Exemption reference number",
      "NGR",
      "Site description",
      "EA area",
      "Exemption code and description",
      "Business type",
      "Contact name",
      "Contact email",
      "Contact phone number",
      "Operator name",
      "Link to registration details"
    ]
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  private

  attr_writer :csv_data
  attr_reader :records, :enrollment_export

  def url_prefix
    Rails.application.routes.url_helpers.admin_enrollments_url
  end

  def full_path
    return nil unless enrollment_export.file_name?

    Rails.root.join "private", "exports", enrollment_export.file_name
  end

  def reportable_records
    FloodRiskEngine::EnrollmentExemption.reportable(enrollment_export.from_date, enrollment_export.to_date)
  end

end
