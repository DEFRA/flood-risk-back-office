module Enrollments
  class AddressForm < FloodRiskEngine::Enrollments::AddressForm

    property :postcode

    validates(
      :postcode,
      presence: {
        message: I18n.t("flood_risk_engine.validation_errors.postcode.blank")
      },
      "flood_risk_engine/postcode" => { allow_blank: true }
    )

    def enrollment_exemption
      enrollment.enrollment_exemptions.last
    end

  end
end
