module Admin
  class EnrollmentsController < ApplicationController

    def new
      authorize FloodRiskEngine::Enrollment

      # This is used later  to ID the enrollment exemption as AD
      bo_enrollment = FloodRiskEngine::Enrollment.create(updated_by_user_id: current_user.id)

      redirect_to flood_risk_engine.enrollment_step_path(bo_enrollment, bo_enrollment.initial_step)
    end
  end
end
