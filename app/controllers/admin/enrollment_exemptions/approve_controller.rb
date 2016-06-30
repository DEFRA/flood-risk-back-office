module Admin
  module EnrollmentExemptions
    class ApproveController < ChangeStatusBaseController

      private

      def authorize_action
        authorize enrollment_exemption, :approve?
      end

      def form_class
        ApproveForm
      end

    end
  end
end
