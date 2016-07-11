module Admin
  class EnrollmentsController < ApplicationController

    def new
      authorize FloodRiskEngine::Enrollment
      redirect_to flood_risk_engine.new_enrollment_path
    end

    def edit
      load_and_authorise_enrollment
    end

    def update
      load_and_authorise_enrollment
      if form.validate(params) && form.save
        redirect_to [:admin, form.enrollment_exemption]
      else
        render :edit
      end
    end

    private

    def load_and_authorise_enrollment
      authorize enrollment
    end

    def enrollment
      @enrollment ||= FloodRiskEngine::Enrollment.find_by_token! params[:id]
    end

    def resume
      authorize FloodRiskEngine::Enrollment
      enrollment.update_attribute(:updated_by_user, current_user)
      redirect_to flood_risk_engine.enrollment_step_path(enrollment, enrollment.step)
    end

    def form
      @form ||= EnrollmentForm.new(enrollment)
    end
    helper_method :form
  end
end
