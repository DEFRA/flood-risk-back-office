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

    records.collect { |record| generate_row(record) }
  end

  def comments(enrollment_exemption)
    enrollment_exemption.comments.collect do |c|
      "#{c.event}\n\t#{c.content}\n"
    end.join("\n")
  end

  # rubocop:disable Metrics/MethodLength
  def generate_row(enrollment_exemption)
    @current_enrollment_exemption = enrollment_exemption

    enrollment          = enrollment_exemption.enrollment
    exemption_location  = enrollment.exemption_location

    presenter = EnrollmentExemptionPresenter.new(enrollment_exemption, nil)

    [
      enrollment_exemption.status,
      presenter.submitted_at,
      ldate(enrollment_exemption.accept_reject_decision_at),
      enrollment_exemption.accept_reject_decision_user.try(:email),
      enrollment_export.created_by,
      presenter.deregister_reason_text,
      presenter.assistance_mode_text,
      presenter.assistance_user,
      presenter.reference_number,
      presenter.grid_reference,
      presenter.description,
      "#{exemption_location.easting},#{exemption_location.northing}",
      presenter.water_management_area_long_name,
      presenter.code,
      presenter.org_type,
      enrollment.correspondence_contact.full_name,
      enrollment.correspondence_contact.email_address,
      enrollment.correspondence_contact.telephone_number,
      presenter.organisation_details,
      comments(enrollment_exemption),
      linkage_url
    ]
  rescue StandardError => e
    Rails.logger.error(
      "Reporting failed due to issue #{e.message} with Enrollment #{enrollment.id} (#{enrollment.reference_number})"
    )
    raise
  end
  # rubocop:enable Metrics/MethodLength

  def self.column_names
    [
      "Registration status",
      "Submitted date",
      "Decision date",
      "Decision maker",
      "Created by",
      "Deregister reason",
      "Assistance mode",
      "Assistance user",
      "Exemption reference number",
      "NGR",
      "Site description", # 10
      "Easting and Northing",
      "Water management area",
      "Exemption code and description",
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

  def ldate(date)
    date ? I18n.l(date, format: :long) : nil
  end

end
