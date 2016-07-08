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

    organisation.partners.each do |partner|
      name_label = I18n.t("admin.enrollment_exemptions.show.main.registration_and_operator.partnership.name")
      address_label = I18n.t("admin.enrollment_exemptions.show.main.registration_and_operator.partnership.address")

      node = content_tag(:p, "#{name_label} #{partner.full_name}") +
             content_tag(:p, "#{address_label} #{present_address(partner.address)}")

      values << node
    end

    values += [
      reference_number,
      submitted_at,
      "" # TODO:  Assisted digital
    ]

    values
  end

end
