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
  delegate :comments, :exemption, :enrollment, :expires_at, :id, :status, :to_model, to: :enrollment_exemption

  delegate :organisation,
           :exemption_location,
           :correspondence_contact,
           :secondary_contact,
           :reference_number,
           to: :enrollment, allow_nil: true

  delegate :code, :summary, to: :exemption, allow_nil: true

  delegate :name, :org_type, :partners, :primary_address, to: :organisation, allow_nil: true

  delegate :description, :grid_reference, to: :exemption_location, allow_nil: true

  def initialize(enrollment_exemption, view_context)
    @enrollment_exemption = enrollment_exemption
    @enrollment = enrollment_exemption.enrollment
    super(view_context)
  end

  def registration_and_operator_data
    Hash[*registration_and_operator_headers.zip(registration_and_operator_values).flatten]
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

  def self.policy_class
    FloodRiskEngine::EnrollmentExemptionPolicy
  end

  def self.reg_panel_max_row
    6
  end

  def self.exemption_panel_max_row
    6
  end

  def organisation_name
    if organisation.try!(:name).present?
      organisation.name
    else
      blank_value
    end
  end

  private

  def present_address(address)
    FloodRiskEngine::AddressPresenter.new(address).to_single_line
  end

  def partnership?
    organisation.try(&:partnership?)
  end

  def registration_and_operator_headers
    if partnership?
      partnership_headers(organisation)
    else
      @headers ||= (1..EnrollmentExemptionPresenter.reg_panel_max_row).collect do |i|
        t("admin.enrollment_exemptions.show.main.registration_and_operator.header_row#{i}")
      end
    end
  end

  def registration_and_operator_values
    if partnership?
      partnership_values(organisation)
    else
      [
        name,
        org_type.to_s.humanize.capitalize,
        present_address(primary_address),
        reference_number,
        submitted_at,
        "" # TODO:  Assisted digital
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
      code,
      summary,
      grid_reference,
      description,
      friendly_expiry_date(enrollment_exemption.expires_at),
      "" # TODO: EA ARea
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
    status_comments.collect { |c| comment_to_html(c) }.join("<hr>")
  end

  def comment_to_html(comment)
    [
      content_tag(:strong, comment.event),
      (comment.content if comment.content.present?),
      content_tag(:em, comment.created_at.to_s(:govuk_date_short))
    ].compact.join("<br>")
  end
end
