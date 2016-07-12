module Admin
  module EnrollmentExemptions
    class AssistanceController < ApplicationController

      before_action :load_and_authorise_enrollment_exemption

      def edit
        render :edit, locals: { form: form_factory, presenter: presenter_factory }
      end

      def update
        form = form_factory
        if form.validate(params) && form.save

          display_mode = EnrollmentExemptionPresenter.assistance_mode_text(assistance_mode)

          redirect_to [:admin, enrollment_exemption], notice: t(".notice", mode: display_mode)
        else
          render :edit, locals: { form: form, presenter: presenter_factory }
        end
      end

      private

      def enrollment_exemption
        @enrollment_exemption ||= FloodRiskEngine::EnrollmentExemption.find(params[:enrollment_exemption_id])
      end
      delegate :assistance_mode, :enrollment, to: :enrollment_exemption

      def form_factory
        AssistanceForm.new(enrollment_exemption, current_user)
      end

      def presenter_factory
        EnrollmentExemptionPresenter.new(enrollment_exemption, view_context)
      end

      def load_and_authorise_enrollment_exemption
        enrollment_exemption
        authorize enrollment_exemption, :assistance?
      end

      def assistance_params
        params.require(:admin_enrollment_assistance_form).permit(:mode, :comment)
      end

    end
  end
end
