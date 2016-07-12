module Admin
  class EnrollmentsController < ApplicationController
    def new
      authorize FloodRiskEngine::Enrollment

      enrollment = FloodRiskEngine::Enrollment.create(updated_by_user_id: current_user.id)

      redirect_to flood_risk_engine.enrollment_step_path(enrollment, enrollment.initial_step)
    end

    def index
      authorize FloodRiskEngine::Enrollment

      enrollment_exemptions = EnrollmentExemptionsQuery.perform(params)
      presenter = EnrollmentExemptionsPresenter.new(enrollment_exemptions, view_context)
      render :index, locals: {
        form: SearchForm.new(params),
        enrollment_exemptions: presenter
      }
    end

    def show
      @enrollment = FloodRiskEngine::Enrollment.find_by_token! params[:id]
      @presenter = EnrollmentPresenter.new(@enrollment, view_context)
      authorize @enrollment
    end

    def edit
      load_and_authorise_enrollment
      # @enrollment.review!
      # TODO: make it go to the first step? Or which step to resume at?
      redirect_to flood_risk_engine.enrollment_step_path(@enrollment, @enrollment.initial_step)
    end

    #  digital_services_core redundant so commenting out for now - not sure why this method here
    #     def resume
    #       load_and_authorise_enrollment
    #       @enrollment.update! updated_by: current_user.email
    #       redirect_to digital_services_core.enrollment_state_path(@enrollment.state, @enrollment)
    #     end

    def load_and_authorise_enrollment
      @enrollment = FloodRiskEngine::Enrollment.find_by_token! params[:id]
      authorize @enrollment
    end
  end
end
