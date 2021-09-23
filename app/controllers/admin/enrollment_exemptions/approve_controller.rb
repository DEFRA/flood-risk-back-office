module Admin
  module EnrollmentExemptions
    class ApproveController < ApplicationController
      before_action :load_and_authorise_enrollment_exemption

      def new
        load_presenter
      end

      def create
        if @enrollment_exemption.action!(enrollment_exemption_params)
          SendRegistrationApprovedEmail.for(@enrollment_exemption)
          redirect_to admin_enrollment_exemption_path(@enrollment_exemption)
        else
          load_presenter
          render :new
        end
      end

      private

      def enrollment_exemption_params
        params.require(:enrollment_exemption).permit(
          :comment_content, :asset_found, :salmonid_river_found
        ).merge(approval_params)
      end

      def approval_params
        {
          status: :approved,
          comment_event: "Approved exemption",
          comment_user_id: current_user.id,
          accept_reject_decision_user_id: current_user.id,
          accept_reject_decision_at: Time.zone.now
        }
      end

      def load_and_authorise_enrollment_exemption
        @enrollment_exemption = EnrollmentExemption.find(params[:enrollment_exemption_id])

        authorize @enrollment_exemption, :approve?
      end

      def load_presenter
        @enrollment_exemption_presenter =
          EnrollmentExemptionPresenter.new(@enrollment_exemption, view_context)
      end
    end
  end
end
