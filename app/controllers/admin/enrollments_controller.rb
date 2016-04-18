module Admin
  class EnrollmentsController < ApplicationController
    def create
      authorize DigitalServicesCore::Enrollment

      en = DigitalServicesCore::Enrollment.create! state_event: "commence",
                                                   assistance_mode: "full",
                                                   created_by: current_user.email,
                                                   updated_by: current_user.email

      msg = I18n.t :admin_enrollment_create_success,
                   assistance_mode: I18n.t(en.assistance_mode, scope: :assistance_modes),
                   ref: en.reference_number

      redirect_to digital_services_core.enrollment_state_path(en.state, en), notice: msg
    end

    # rubocop:disable Metrics/AbcSize
    def index
      authorize DigitalServicesCore::Enrollment

      rel = policy_scope(EnrollmentSearch).prefixed_any_search params[:q]

      stage = params[:stage]

      rel =
        if stage.blank? || stage == "submitted"
          rel.merge DigitalServicesCore::Enrollment.submitted
        elsif stage == "not_submitted"
          rel.merge DigitalServicesCore::Enrollment.not_submitted
        else
          # search for all stages of registration (not-submitted and submitted)
          rel
        end

      rel = rel.
            joins(:enrollment).
            joins("LEFT OUTER JOIN dsc_organisations " \
                  "ON dsc_organisations.id = dsc_enrollments.organisation_id").
            order("dsc_organisations.name").
            includes(enrollment: [
                      :organisation, :site_address,
                      { applicant_contact: :addresses },
                      { correspondence_contact: :addresses }
                     ])

      @enrollment_results = rel.page params[:page]
    end

    def show
      @enrollment = DigitalServicesCore::Enrollment.find params[:id]
      @presenter = EnrollmentPresenter.new(@enrollment, view_context)
      authorize @enrollment
    end

    def edit
      @enrollment = DigitalServicesCore::Enrollment.submitted.find params[:id]
      authorize @enrollment
      @enrollment.review!
      redirect_to digital_services_core.enrollment_state_path("review", @enrollment)
    end

    def resume
      enrollment = DigitalServicesCore::Enrollment.find params[:id]
      authorize enrollment
      enrollment.update! updated_by: current_user.email
      redirect_to digital_services_core.enrollment_state_path(enrollment.state, enrollment)
    end
  end
end
