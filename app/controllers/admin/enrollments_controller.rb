module Admin
  class EnrollmentsController < ApplicationController

    def new
      authorize FloodRiskEngine::Enrollment

      # This is used later  to ID the enrollment exemption as AD
      bo_enrollment = FloodRiskEngine::Enrollment.create(updated_by_user_id: current_user.id)

      redirect_to flood_risk_engine.enrollment_step_path(bo_enrollment, bo_enrollment.initial_step)
    end

    def edit
      load_and_authorise_enrollment
    end

    def update
      load_and_authorise_enrollment
      if form.validate(params) && form.save
        redirect_to admin_enrollment_exemption_path(form.enrollment_exemption)
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
