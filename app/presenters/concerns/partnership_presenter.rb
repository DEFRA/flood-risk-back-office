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
             content_tag(:p, sanitize("#{address_label} #{address_for(partner)}", tag: ["a"]))

      values << node
    end

    values += [
      reference_number,
      submitted_at,
      assistance_mode_text
    ]

    values
  end

  def address_for(partner)
    # Checking that `link_to` is available is a hack to allow this spec to work:
    #   spec/presenters/enrollment_exemption_presenter_spec.rb
    if respond_to?(:link_to)
      editable_present_address(partner.address)
    else
      present_address(partner.address)
    end
  end

end
