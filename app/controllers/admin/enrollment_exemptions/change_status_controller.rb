module Admin
  module EnrollmentExemptions
    class ChangeStatusController < ChangeStatusBaseController

      private

      def authorize_action
        authorize enrollment_exemption, :change_status?
      end

      def form_class
        ChangeStatusForm
      end

    end
  end
end
