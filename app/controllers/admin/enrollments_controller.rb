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

      # rel = policy_scope(EnrollmentSearch).prefixed_any_search params[:q]

      # stage = params[:stage]

      # rel =
      #   if stage.blank? || stage == "submitted"
      #     rel.merge FloodRiskEngine::Enrollment.submitted
      #   elsif stage == "not_submitted"
      #     rel.merge FloodRiskEngine::Enrollment.not_submitted
      #   else
      #     # search for all stages of registration (not-submitted and submitted)
      #     rel
      #   end

      # rel = rel.
      #       joins(:enrollment).
      #       joins("LEFT OUTER JOIN dsc_organisations " \
      #             "ON dsc_organisations.id = dsc_enrollments.organisation_id").
      #       order("dsc_organisations.name").
      #       includes(enrollment: [
      #                 :organisation, :site_address,
      #                 { applicant_contact: :addresses },
      #                 { correspondence_contact: :addresses }
      #                ])

      # @enrollment_results    =  rel.page params[:page]
      @enrollment_results = FloodRiskEngine::Enrollment.none
    end

    def show
      @enrollment = FloodRiskEngine::Enrollment.find params[:id]
      @presenter = EnrollmentPresenter.new(@enrollment, view_context)
      authorize @enrollment
    end

    def edit
      @enrollment = FloodRiskEngine::Enrollment.submitted.find params[:id]
      authorize @enrollment
      @enrollment.review!
      redirect_to digital_services_core.enrollment_state_path("review", @enrollment)
    end

    def resume
      enrollment = FloodRiskEngine::Enrollment.find params[:id]
      authorize enrollment
      enrollment.update! updated_by: current_user.email
      redirect_to digital_services_core.enrollment_state_path(enrollment.state, enrollment)
    end
  end
end
