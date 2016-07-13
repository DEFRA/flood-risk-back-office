module Enrollments
  class AddressesController < FloodRiskEngine::Enrollments::AddressesController

    before_action :set_paper_trail_whodunnit

    def update
      if save_form!
        redirect_to admin_enrollment_exemption_path(enrollment_exemption)
      else
        render :edit
      end
    end

    def enrollment_exemption
      enrollment.enrollment_exemptions.first
    end

    def form
      @form ||= AddressForm.new(enrollment, address)
    end

  end
end
