module Admin

  class EnrollmentExemptionForm < BaseForm

    def initialize(model)
      super(model)
    end

    def params_key
      :admin_enrollment_exemption
    end

  end
end
