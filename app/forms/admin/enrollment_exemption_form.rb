module Admin

  class EnrollmentExemptionForm < AdminBaseForm

    def initialize(model)
      super(model)
    end

    def params_key
      :admin_enrollment_exemption
    end

  end
end
