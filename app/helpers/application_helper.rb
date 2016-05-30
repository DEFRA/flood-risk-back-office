module ApplicationHelper

  def page_title(title)
    return unless title.present?

    stripped_title = title.gsub(/’/, %('))

    if content_for? :page_title
      content_for :page_title, " | #{stripped_title}"
    else
      content_for :page_title, "GOV.UK | #{stripped_title}"
    end

    title
  end

  def cancel_go_back_link
    if request.referer.present?
      link_to glyphicon_tag(:triangle_left, text: t("cancel_go_back")), :back,
              class: "ignore-visited"
    else
      link_to glyphicon_tag(:ban_circle, text: t("cancel")), main_app.root_path,
              class: "ignore-visited"
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

    html.html_safe
  end
end
