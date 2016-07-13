module PartnershipPresenter

  extend ActiveSupport::Concern

  def self.registration_panel_max_row
    4
  end

  def partnership_headers(organisation)
    @headers ||= (1..PartnershipPresenter.registration_panel_max_row).collect do |i|
      I18n.t("admin.enrollment_exemptions.show.main.registration_and_operator.partnership.header_row#{i}")
    end

    partners_header = "admin.enrollment_exemptions.show.main.registration_and_operator.partnership.label"

    # 1 row per partner
    partners = (1..organisation.partners.size).collect { |idx| I18n.t(partners_header, index: idx) }

    @headers.insert(1, *partners)

    @headers
  end

  def partnership_values(organisation)
    values = [organisation.org_type.humanize.capitalize]
    values << organisation.partners.collect { |partner| node_for(partner) }
    values << [
      reference_number,
      submitted_at,
      assistance_mode_text
    ]
    values.flatten!
  end

  def edit_link(partner)
    link_to(
      I18n.t(".edit"),
      edit_enrollment_partner_path(enrollment, partner),
      class: "btn btn-xs btn-primary"
    )
  end

  def node_for(partner)
    sanitize(
      [
        content_tag(:p, "#{name_label} #{partner.full_name}"),
        content_tag(:p, "#{address_label} #{present_address(partner.address)}"),
        content_tag(:p, edit_link(partner))
      ].join,
      tag: %w(a p)
    )
  end

  def name_label
    I18n.t("admin.enrollment_exemptions.show.main.registration_and_operator.partnership.name")
  end

  def address_label
    I18n.t("admin.enrollment_exemptions.show.main.registration_and_operator.partnership.address")
  end

end
