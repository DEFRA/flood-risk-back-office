
class EnrollmentExemptionPresenter < Presenter
  include PartnershipPresenter
  include StatusTag

  delegate :exemption, :enrollment, :id, :status, :to_model, to: :enrollment_exemption

  delegate :organisation,
           :exemption_location,
           :correspondence_contact,
           :secondary_contact,
           :reference_number,
           to: :enrollment, allow_nil: true

  delegate :code, :summary, to: :exemption

  delegate :org_type, :partners, :primary_address, to: :organisation

  delegate :name, to: :organisation, prefix: true, allow_nil: true

  delegate :grid_reference, to: :exemption_location, allow_nil: true

  def initialize(enrollment_exemption, view_context)
    @enrollment_exemption = enrollment_exemption
    @enrollment = enrollment_exemption.enrollment
    super(view_context)
  end

  def registration_and_operator_data
    Hash[*registration_and_operator_headers.zip(registration_and_operator_values).flatten]
  end

  def exemption_data
    Hash[*exemption_headers.zip(exemption_values).flatten]
  end

  def status_tag
    super(enrollment_exemption.status, status_label, status_options)
  end

  def submitted_at
    I18n.l(enrollment.created_at, format: :long)
  end

  def self.policy_class
    FloodRiskEngine::EnrollmentExemptionPolicy
  end

  def self.reg_panel_max_row
    6
  end

  def self.exemption_panel_max_row
    6
  end

  private

  def present_address(address)
    FloodRiskEngine::AddressPresenter.new(address).to_single_line
  end

  def registration_and_operator_headers
    if organisation.partnership?
      partnership_headers(organisation)
    else
      @headers ||= (1..EnrollmentExemptionPresenter.reg_panel_max_row).collect do |i|
        t("admin.enrollment_exemptions.show.main.registration_and_operator.header_row#{i}")
      end
    end
  end

  def registration_and_operator_values
    if organisation.partnership?
      partnership_values(organisation)
    else
      [
        organisation.name,
        org_type.humanize.capitalize,
        present_address(primary_address),
        reference_number,
        submitted_at,
        "TBD Assisted digital"
      ]
    end
  end

  def exemption_headers
    @exemption_headers ||= (1..EnrollmentExemptionPresenter.exemption_panel_max_row).collect do |i|
      t("admin.enrollment_exemptions.show.main.exemption_panel.header_row#{i}")
    end
  end

  def exemption_values
    [
      exemption.code,
      exemption.summary,
      exemption_location.grid_reference,
      exemption_location.description,
      friendly_expiry_date(enrollment_exemption.expires_at),
      "TBD EA Area"
    ]
  end

  attr_reader :enrollment_exemption

  def exemption
    enrollment_exemption.exemption
  end

  def status_label
    I18n.t(status, scope: "admin.enrollment_exemptions.show.main.exemption_panel.status_label")
  end

  def status_options
    {
      title: status_tooltip_html, "aria-haspopup": "true", data: { toggle: "tooltip", html: true }
    }
  end

  def status_tooltip_html
    # TODO: NCCC Workflow not in place yet - not sure the status/workflow to go here
    # clazz = FloodRiskEngine::EnrollmentExemption
    # tooltip1 = [content_tag(:em, clazz.human_attribute_name(:deregistered_at)), deregistered_at].join(": <br/>")
    tooltip1 = [content_tag(:em, "TBD"), status].join(": <br/>")

    # tooltip2 = if enrollment_exemption.deregistered_comment?
    #            [content_tag(:em, clazz.human_attribute_name(:deregistered_comment)),
    #           simple_format(enrollment_exemption.deregistered_comment)].join(": <br/>")
    #         end
    tooltip2 = [content_tag(:em, "TBD"), simple_format("TBC Comment")].join(": <br/>")

    [tooltip1, tooltip2].compact.join("<br/><br/>")
  end
end
