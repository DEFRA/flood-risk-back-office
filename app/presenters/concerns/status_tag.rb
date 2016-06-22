module StatusTag
  extend ActiveSupport::Concern

  STATUS_TO_CSS_CLASS_MAP = {
    building: "info",
    pending: "warning",
    being_processed: "info",
    approved: "success",
    rejected: "danger",
    expired:  "danger",
    withdrawn: "danger"
  }.freeze

  def status_tag_css_class(status)
    return unless status
    suffix = STATUS_TO_CSS_CLASS_MAP.fetch(status.to_sym) { "default" }
    "label-#{suffix}"
  end

  # Creates a styled enrollment or enrollment/exemption status span with
  # Example usage:
  #   status_tag("approved", "Approved on", { data: ... })

  def status_tag(status, body, options = {})
    default_options = { class: "label #{status_tag_css_class(status)}", style: "padding:0.7em;" }
    opts = default_options.merge(options || {})
    content_tag(:span, body, opts).html_safe
  end
end
