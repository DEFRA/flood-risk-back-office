module Admin
  module EnrollmentExemptions
    class ResendApprovalEmailController < ChangeStatusBaseController

      private

      def authorize_action
        authorize enrollment_exemption, :resend_approval_email?
      end

      def form_class
        ResendApprovalEmailForm
      end

    end
  end
end
