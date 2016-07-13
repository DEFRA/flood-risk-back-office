module Admin
  module EnrollmentExemptions
    class WithdrawController < ChangeStatusBaseController

      private

      def authorize_action
        authorize enrollment_exemption, :withdraw?
      end

      def form_class
        WithdrawForm
      end

    end
  end
end
