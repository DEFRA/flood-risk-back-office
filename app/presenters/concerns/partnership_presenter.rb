module PartnershipPresenter

  extend ActiveSupport::Concern

  def partnership_headers(organisation)
    headers = [t("admin.enrollment_exemptions.show.main.registration_and_operator.header_row2")]

    partner_label = "admin.enrollment_exemptions.show.main.registration_and_operator.partnership.label"

    (1..organisation.partners.size).each { |idx| headers << t(partner_label, index: idx) }

    shared_between_partners_and_other_org_types = (4..EnrollmentExemptionPresenter.reg_panel_max_row)

    headers += shared_between_partners_and_other_org_types.collect do |i|
      t("admin.enrollment_exemptions.show.main.registration_and_operator.header_row#{i}")
    end

    headers
  end

  def partnership_values(organisation)
    values = [organisation.org_type.humanize.capitalize]

    organisation.partners.each do |partner|
      name_label = t("admin.enrollment_exemptions.show.main.registration_and_operator.partnership.name")
      address_label = t("admin.enrollment_exemptions.show.main.registration_and_operator.partnership.address")

      node = content_tag(:p, "#{name_label} #{partner.full_name}") +
             content_tag(:p, "#{address_label} #{present_address(partner.address)}")

      values << node
    end

    values += [
      reference_number,
      "TBD Submitted on",
      "TBD Assisted digital"
    ]

    values
  end

end
