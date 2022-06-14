module Admin
  module EnrollmentExemptions
    class DeregisterController < ApplicationController
      before_action :load_and_authorise_enrollment_exemption

      def new
        load_page_defaults
      end

      def create
        if @enrollment_exemption.action!(deregister_params)
          redirect_to admin_enrollment_exemption_path(@enrollment_exemption)
        else
          load_page_defaults
          render :new
        end
      end

      private

      def enrollment_exemption_params
        params.require(:enrollment_exemption).permit(
          :comment_content, :deregister_reason
        )
      end

      def deregister_params
        enrollment_exemption_params.merge(
          {
            status: :deregistered,
            comment_event:,
            comment_user_id: current_user.id
          }
        )
      end

      def comment_event
        "Deregistered exemption with #{enrollment_exemption_params[:deregister_reason].to_s.humanize}"
      end

      def load_and_authorise_enrollment_exemption
        @enrollment_exemption = EnrollmentExemption.find(params[:enrollment_exemption_id])

        authorize @enrollment_exemption, :deregister?
      end

      def load_page_defaults
        @deregister_reasons = FloodRiskEngine::EnrollmentExemption.deregister_reasons.keys

        @enrollment_exemption_presenter =
          EnrollmentExemptionPresenter.new(@enrollment_exemption, view_context)
      end
    end
  end
end
