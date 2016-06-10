
class EnrollmentExemptionPresenter < Presenter
  # include DeregistrationReasons
  # include StatusTag

  delegate :id,
           :to_param,
           :to_model,
           :code,
           :deregistered_comment,
           :active?,
           :exemption,
           :enrollment,
           to: :enrollment_exemption

  delegate :organisation,
           :exemption_location,
           :correspondence_contact,
           to: :enrollment,
           allow_nil: true

  delegate :code, :summary, to: :exemption

  delegate :summary,
           :org_type,
           to: :enrollment,
           prefix: true

  delegate :org_type, to: :organisation
  delegate :name, to: :organisation, prefix: true, allow_nil: true

  delegate :grid_reference, to: :exemption_location, allow_nil: true

  def initialize(enrollment_exemption, view_context)
    @enrollment_exemption = enrollment_exemption
    @enrollment = enrollment_exemption.enrollment
    @organisation = enrollment.organisation
    super(view_context)
  end

  def status_tag
    super(enrollment_exemption.status, status_label, status_options)
  end

  def exemption_code_tag
    content_tag(:span, exemption.code, class: "badge").html_safe
  end

  def expires_at
    return unless enrollment_exemption.active? || enrollment_exemption.expired?
    friendly_date(enrollment_exemption.expires_at)
  end

  def submitted_at
    I18n.l(enrollment.created_at, format: :long)
  end

  def deregistered_at
    date = if enrollment_exemption.expired?
             enrollment_exemption.deregistered_at || enrollment_exemption.expires_at
           else
             enrollment_exemption.deregistered_at
           end
    friendly_date(date)
  end

  def self.policy_class
    FloodRiskEngine::EnrollmentExemptionPolicy
  end

  private

  attr_reader :enrollment_exemption

  def exemption
    enrollment_exemption.exemption
  end

  def status_label
    I18n.t(enrollment_exemption.status,
           scope: "waste_exemptions_shared.enrollment_exemption_statuses")
  end

  def status_options
    if enrollment_exemption.deregistered_at && !active?
      status_opts = {}
      status_opts[:title] = status_tooltip_html
      status_opts["aria-haspopup"] = "true"
      status_opts[:data] = { toggle: "tooltip", html: true }
      status_opts
    end
  end

  def status_tooltip_html
    clazz = WasteExemptionsShared::EnrollmentExemption
    tooltip1 = [content_tag(:em, clazz.human_attribute_name(:deregistered_at)),
                deregistered_at].join(": <br/>")

    tooltip2 = if enrollment_exemption.deregistered_comment?
                 [content_tag(:em, clazz.human_attribute_name(:deregistered_comment)),
                  simple_format(enrollment_exemption.deregistered_comment)].join(": <br/>")
               end

    [tooltip1, tooltip2].compact.join("<br/><br/>")
  end
end
