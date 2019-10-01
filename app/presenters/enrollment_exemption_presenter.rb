# rubocop:disable Metrics/ClassLength

# Note  - From the View page INCOMPLETE registrations can be found and viewed
# So this Presenter should never assume underlying data is actually present
#
class EnrollmentExemptionPresenter < Presenter
  include PartnershipPresenter
  include StatusTag
  include ActionView::Helpers::TagHelper # for content_tag
  include ActionView::Helpers::TextHelper # for simple_format

  attr_reader :enrollment_exemption

  delegate :assistance_mode,
           :comments,
           :deregister_reason,
           :exemption,
           :enrollment,
           :expires_at,
           :id,
           :status,
           :to_model,
           to: :enrollment_exemption

  delegate :organisation,
           :exemption_location,
           :correspondence_contact,
           :secondary_contact,
           :reference_number,
           to: :enrollment, allow_nil: true

  delegate :code, :summary, to: :exemption, allow_nil: true

  delegate :name, :org_type, :partners, :primary_address, :registration_number, to: :organisation, allow_nil: true

  delegate :description, :grid_reference, to: :exemption_location, allow_nil: true

  delegate :water_management_area, to: :exemption_location, allow_nil: true

  delegate :long_name, to: :water_management_area, prefix: true, allow_nil: true

  def initialize(enrollment_exemption, view_context)
    @enrollment_exemption = enrollment_exemption
    @enrollment = enrollment_exemption.enrollment
    super(view_context)
  end

  def registration_and_operator_data
    Hash[*registration_and_operator_headers.zip(registration_and_operator_values).flatten]
  end

  def assistance_modes_map
    EnrollmentExemptionPresenter.assistance_modes_map
  end

  def self.assistance_modes_map
    FloodRiskEngine::EnrollmentExemption.assistance_modes.keys.collect do |s|
      [assistance_mode_text(s), s]
    end
  end

  def self.assistance_mode_text(mode)
    @assistance_mode_text_locale ||= "admin.enrollment_exemptions.assistance.modes"
    I18n.t("#{@assistance_mode_text_locale}.#{mode}")
  end

  def assistance_mode_text
    self.class.assistance_mode_text(assistance_mode)
  end

  def assistance_user
    # Used in FO/engine which has no devise User hence an ID not a User association
    # only filled in for Assisted enrollments so nil perfectly acceptable
    User.find_by(id: enrollment.updated_by_user_id).try(:email)
  end

  def deregister_reason_text
    return "" unless enrollment_exemption.deregister_reason

    enrollment_exemption.deregister_reason.humanize
  end

  def status
    enrollment_exemption.status.humanize
  end

  def exemption_data
    Hash[*exemption_headers.zip(exemption_values).flatten]
  end

  def status_tag(options: status_options)
    super(enrollment_exemption.status, status_label, options)
  end

  def status_tag_without_popup
    status_tag(options: {})
  end

  def submitted_at
    enrollment.submitted_at && I18n.l(enrollment.submitted_at, format: :long)
  end

  def created_at
    enrollment.created_at && I18n.l(enrollment.created_at, format: :long)
  end

  def self.policy_class
    FloodRiskEngine::EnrollmentExemptionPolicy
  end

  def self.reg_panel_max_row
    6
  end

  # For partnerships we sometimes need ALL names not just the first
  def organisation_details
    return blank_value unless organisation

    organisation.partnership? ? partner_names : organisation.name
  end

  def organisation_name
    return blank_value unless organisation

    organisation.partnership? ? first_partner_name : organisation.name
  end

  def organisation_address
    address ? present_address(address) : blank_value
  end

  private

  def address
    return unless organisation

    organisation.partnership? ? first_partner_address : organisation.primary_address
  end

  def partner_names
    organisation.partners.collect { |p| p.contact.full_name }.join(",")
  end

  def first_partner_name
    partner = organisation.partners.first
    partner&.contact&.full_name
  end

  def first_partner_address
    partner = organisation.partners.first
    partner&.address
  end

  def present_address(address)
    FloodRiskEngine::AddressPresenter.new(address).to_single_line
  end

  def editable_present_address(address)
    return unless address

    with_edit_button(
      text: present_address(address),
      url: edit_enrollment_address_path(enrollment, address)
    )
  end

  def with_edit_button(text:, url:)
    link = link_to(I18n.t(".edit"), url, class: "btn btn-xs btn-primary")
    sanitize [text, link].join(" "), tags: ["a"]
  end

  def partnership?
    organisation.try(&:partnership?)
  end

  # The top Registration details Panel

  def registration_and_operator_headers
    if partnership?
      partnership_headers(organisation)
    else
      @headers ||= I18n.t("admin.enrollment_exemptions.show.main.registration_and_operator.headers").to_a
    end
  end

  def registration_and_operator_values
    if partnership?
      partnership_values(organisation)
    else
      [
        name,
        organisation_type,
        editable_present_address(primary_address),
        reference_number,
        submitted_at,
        assistance_mode_text
      ]
    end
  end

  def organisation_type
    [humanized_org_type, registration_number].select(&:present?).join(" - ")
  end

  def humanized_org_type
    org_type.to_s.humanize.capitalize
  end

  # Same regardless of Organisation Type

  def exemption_headers
    @exemption_headers ||= I18n.t("admin.enrollment_exemptions.show.main.exemption_panel.headers").to_a
  end

  def exemption_values
    [
      code,
      summary,
      grid_reference,
      description,
      water_management_area_long_name
    ]
  end

  def status_label
    I18n.t(enrollment_exemption.status, scope: "admin.status_label")
  end

  def status_options
    {
      title: status_tooltip_html, "aria-haspopup": "true", data: { toggle: "tooltip", html: true }
    }
  end

  def status_comments
    comments.order(created_at: :desc)
  end

  def status_tooltip_html
    return if comments.empty?

    comment_to_html status_comments.first
  end

  def comment_to_html(comment)
    [
      content_tag(:strong, comment.event),
      (comment.content if comment.content.present?),
      content_tag(:em, comment.created_at.to_s(:govuk_date_short))
    ].compact.join("<br>")
  end

  protected

  attr_accessor :headers

end
# rubocop:enable Metrics/ClassLength
