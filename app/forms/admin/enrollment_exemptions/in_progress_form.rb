module Admin
  module EnrollmentExemptions
    class InProgressForm < BaseChangeStateForm

      def params_key
        :admin_enrollment_exemptions_in_progress
      end

      def self.locale_key
        "admin.enrollment_exemptions.in_progress.new"
      end

      # create_comment expects content via comment property but we've no comment panel and nothing else to say
      def comment; end

      def save
        enrollment_exemption.accept_reject_decision_user_id = user.id
        enrollment_exemption.being_processed!

        super

        create_comment("Status changed to In Progress")
      end

    end
  end
end
