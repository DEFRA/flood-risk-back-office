module Admin
  module EnrollmentExemptions
    class ChangeStatusController < ApplicationController
      before_action :load_and_authorise_enrollment_exemption

      def new
        load_page_defaults
      end

      def create
        update_params = enrollment_exemption_params.merge(comment_event: comment_event)

        if @enrollment_exemption.action!(update_params)
          redirect_to admin_enrollment_exemption_path(@enrollment_exemption)
        else
          load_page_defaults
          render :new
        end
      end

      private

      def enrollment_exemption_params
        params.require(:enrollment_exemption).permit(
          :status, :comment_content
        )
      end

      def load_and_authorise_enrollment_exemption
        @enrollment_exemption = EnrollmentExemption.find(params[:enrollment_exemption_id])

        authorize @enrollment_exemption, :change_status?
      end

      def load_page_defaults
        @status_keys = EnrollmentExemption.status_keys
        @enrollment_exemption_presenter =
          EnrollmentExemptionPresenter.new(@enrollment_exemption, view_context)
      end

      def comment_event
        "Changed exemption from #{@enrollment_exemption.status} to #{enrollment_exemption_params[:status]}"
      end
    end
  end
end
