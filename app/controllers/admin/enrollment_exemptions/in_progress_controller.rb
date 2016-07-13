module Admin
  module EnrollmentExemptions
    class InProgressController < ChangeStatusBaseController

      private

      def authorize_action
        authorize enrollment_exemption, :in_progress?
      end

      def form_class
        InProgressForm
      end

    end
  end
end
