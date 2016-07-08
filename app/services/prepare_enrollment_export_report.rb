class PrepareEnrollmentExportReport

  attr_reader :csv_data

  def initialize(enrollment_export)
    @enrollment_export = enrollment_export

    @csv_data = []
  end

  def self.run(enrollment_export)
    new(enrollment_export).call
  end

  def call
    @records = enrollment_export.reportable_records

    enrollment_export.update!(record_count: records.size) if records

    csv_data = records.collect { |record| generate_row(record) }

    csv_data
  end

  def comments(enrollment_exemption)
    enrollment_exemption.comments.collect do |c|
      "#{c.event}\n\t#{c.content}\n"
    end.join("\n")
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def generate_row(enrollment_exemption)
    @current_enrollment_exemption = enrollment_exemption

    enrollment = enrollment_exemption.enrollment

    [
      enrollment_exemption.status,
      ldate(enrollment.submitted_at, format: :long),
      ldate(enrollment_exemption.accept_reject_decision_at, format: :long),
      enrollment_exemption.accept_reject_decision_user.try(:email),
      enrollment_export.created_by,
      enrollment.reference_number,
      enrollment.exemption_location.grid_reference,
      enrollment.exemption_location.description,
      "#{enrollment.exemption_location.easting},#{enrollment.exemption_location.northing}",
      "", # TODO: EA Area
      enrollment.exemptions.first.code,
      enrollment.organisation.org_type,
      enrollment.correspondence_contact.full_name,
      enrollment.correspondence_contact.email_address,
      enrollment.correspondence_contact.telephone_number,
      enrollment.organisation.name,
      comments(enrollment_exemption),
      linkage_url
    ]
  rescue => x
    Rails.logger.error(
      "Reporting failed due to issue #{x.message} with Enrollment #{enrollment.id} (#{enrollment.reference_number})"
    )
    raise
  end

  def self.column_names
    [
      "Registration status",              # 1.
      "Submitted date",
      "Decision date",
      "Decision maker",
      "Created by",
      "Exemption reference number",
      "NGR",
      "Site description",
      "Easting and Northing",
      "EA area",
      "Exemption code and description",   # 10.
      "Business type",
      "Contact name",
      "Contact email",
      "Contact phone number",
      "Operator name",
      "Comments",
      "Link to registration details"
    ]
  end

  private

  attr_writer :csv_data
  attr_reader :current_enrollment_exemption, :records, :enrollment_export

  def linkage_url
    "#{url_prefix}/#{current_enrollment_exemption.id}"
  end

  def url_prefix
    Rails.application.routes.url_helpers.admin_enrollment_exemptions_url
  end

  def full_path
    return nil unless enrollment_export.file_name?

    Rails.root.join "private", "exports", enrollment_export.file_name
  end

  def ldate(dt, hash = {})
    dt ? I18n.l(dt, hash) : nil
  end

end
