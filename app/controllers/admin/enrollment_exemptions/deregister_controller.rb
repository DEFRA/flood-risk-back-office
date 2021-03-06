module Admin
  module EnrollmentExemptions
    class DeregisterController < ChangeStatusBaseController

      private

      def authorize_action
        authorize enrollment_exemption, :deregister?
      end

      def form_class
        DeregisterForm
      end

    end
  end
end
