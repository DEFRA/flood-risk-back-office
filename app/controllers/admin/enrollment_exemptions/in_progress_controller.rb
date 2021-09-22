module Admin
  module EnrollmentExemptions
    class InProgressController < ApplicationController
      before_action :load_and_authorise_enrollment_exemption

      def new
        load_presenter
      end

      def create
        if @enrollment_exemption.action!(in_progress_params)
          redirect_to admin_enrollment_exemption_path(@enrollment_exemption)
        else
          load_presenter
          render :new
        end
      end

      private

      def in_progress_params
        {
          status: :being_processed,
          comment_content: "n/a",
          comment_event: "Status changed to In progress"
        }
      end

      def load_and_authorise_enrollment_exemption
        @enrollment_exemption = EnrollmentExemption.find(params[:enrollment_exemption_id])

        authorize @enrollment_exemption, :in_progress?
      end

      def load_presenter
        @enrollment_exemption_presenter =
          EnrollmentExemptionPresenter.new(@enrollment_exemption, view_context)
      end
    end
  end
end
