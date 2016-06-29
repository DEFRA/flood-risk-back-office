module Admin
  module EnrollmentExemptions
    class RejectController < ChangeStatusBaseController

      private

      def authorize_action
        authorize enrollment_exemption, :reject?
      end

      def form_class
        RejectForm
      end

    end
  end
end
