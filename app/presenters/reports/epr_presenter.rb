# frozen_string_literal: true

module Reports
  class EprPresenter < SimpleDelegator#FloodRiskEngine::BasePresenter
    delegate :reference_number, :exemption_location, :organisation, to: :enrollment, allow_nil: true
    delegate :grid_reference, :water_management_area, to: :exemption_location, allow_nil: true
    delegate :long_name, to: :water_management_area, prefix: true, allow_nil: true
    delegate :code, to: :exemption, allow_nil: true

    def accept_reject_decision_at
      super && I18n.l(super, format: :year_month_day_hyphens)
    end

    # For partnerships we sometimes need ALL names not just the first
    def organisation_details
      return blank_value unless organisation
      return partner_names if organisation.partnership?

      organisation.name
    end

    private

    def partner_names
      organisation.partners.collect do |partner|
        partner.contact.full_name
      end.join(", ")
    end

    def blank_value
      @_blank_value ||= I18n.t("presenters.blank")
    end
  end
end
