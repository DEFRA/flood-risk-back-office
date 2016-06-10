module Admin
  class EnrollmentsController < ApplicationController
    def new
      authorize FloodRiskEngine::Enrollment
      redirect_to flood_risk_engine.new_enrollment_path
    end

    # def create
    #   authorize FloodRiskEngine::Enrollment

    #   en = FloodRiskEngine::Enrollment.create #! state_event: "commence",
    #                                           #   assistance_mode: "full",
    #                                           #   created_by: current_user.email,
    #                                           #   updated_by: current_user.email

    #   # msg = I18n.t :admin_enrollment_create_success,
    #   #              assistance_mode: I18n.t(en.assistance_mode, scope: :assistance_modes),
    #   #              ref: en.reference_number

    #   redirect_to flood_risk_engine.step_enrollment_path(en)#.state, en)#, notice: msg
    # end

    def index
      authorize FloodRiskEngine::Enrollment

      enrollment_exemptions = EnrollmentExemptionsQuery.perform(params)
      presenter = EnrollmentExemptionsPresenter.new(enrollment_exemptions, view_context)

      render :index, locals: {
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

    def resume
      load_and_authorise_enrollment
      @enrollment.update! updated_by: current_user.email
      redirect_to digital_services_core.enrollment_state_path(@enrollment.state, @enrollment)
    end

    def load_and_authorise_enrollment
      @enrollment = FloodRiskEngine::Enrollment.find_by_token! params[:id]
      authorize @enrollment
    end
  end
end
