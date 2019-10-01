module Enrollments
  class PartnersController < ApplicationController

    def edit
      authorize FloodRiskEngine::Partner
    end

    def update
      authorize FloodRiskEngine::Partner
      if save_form!
        redirect_to admin_enrollment_exemption_path(enrollment_exemption)
      else
        render :edit
      end
    end

    private

    def partner
      @partner ||= FloodRiskEngine::Partner.find(params[:id])
    end

    def enrollment
      @enrollment ||= FloodRiskEngine::Enrollment.find_by(token: params[:enrollment_id])
    end

    def form
      @form ||= PartnerForm.new(enrollment, partner)
    end
    helper_method :form

    def enrollment_exemption
      enrollment.enrollment_exemptions.first
    end

    def save_form!
      return false unless form.validate(params)

      form.save
    end
  end
end
