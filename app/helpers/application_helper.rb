module ApplicationHelper

  def open_close_tag(target, open = false)
    icon = glyphicon_tag(open ? :chevron_up : :chevron_down)
    link_to icon, "##{target}", role: "button", "data-toggle" => "collapse",
                                "aria-expanded" => "true", "aria-controls" => target
  end

  def cancel_go_back_link
    if request.referer.present?
      link_to glyphicon_tag(:triangle_left, text: t("cancel_go_back")), :back, class: "ignore-visited"
    else
      link_to glyphicon_tag(:ban_circle, text: t("cancel")), main_app.root_path, class: "ignore-visited"
    end
  end

  def glyphicon_tag(icon, text: nil, tooltip: nil, tooltip_is_html: false)
    icon = icon.to_s.tr("_", "-")

    opts = {}
    if tooltip.present?
      opts[:title] = tooltip
      opts["aria-haspopup"] = "true"
      opts[:data] = { toggle: "tooltip", html: tooltip_is_html }
    end

    html = content_tag :span, "", opts.merge(class: "glyphicon glyphicon-#{icon}", "aria-hidden" => "true")
    html += " #{text}" if text.present?

    html
  end

  def full_devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.messages.map do |_k, msgs|
      content_tag(:li, msgs.to_sentence) if msgs.any?
    end

    html = <<-HTML.strip_heredoc
      <div class="#{SimpleForm.error_notification_class}">
        <ul>#{messages.reject(&:blank?).join}</ul>
      </div>
      HTML

    html
  end
end
