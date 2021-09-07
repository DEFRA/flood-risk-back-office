module Enrollments
  class AddressForm < FloodRiskEngine::Enrollments::AddressForm
    def self.t(locale, args = {})
      I18n.t "enrollments.addresses#{locale}", args
    end

    def t(*args)
      self.class.t(*args)
    end

    property :postcode

    validates(
      :postcode,
      presence: {
        message: I18n.t("flood_risk_engine.validation_errors.postcode.blank")
      },
      "flood_risk_engine/legacy_postcode" => { allow_blank: true }
    )

    def enrollment_exemption
      enrollment.enrollment_exemptions.last
    end

  end
end
