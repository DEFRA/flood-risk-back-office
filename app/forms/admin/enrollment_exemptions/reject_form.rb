
module Admin
  module EnrollmentExemptions
    class RejectForm < BaseChangeStateForm

      def params_key
        :admin_enrollment_exemptions_reject
      end

      def self.locale_key
        "admin.enrollment_exemptions.reject.new"
      end

      property :comment, virtual: true
      validates(
        :comment,
        presence: { message: t(".errors.comment.blank") },
        length: {
          maximum: COMMENT_MAX_LENGTH,
          message: t(".errors.comment.too_long", max: COMMENT_MAX_LENGTH)
        }
      )

      def comment_max_length
        COMMENT_MAX_LENGTH
      end

      def save
        create_comment
        enrollment_exemption.rejected!
        SendRegistrationRejectedEmail.for enrollment_exemption
      end

      def create_comment
        super "Rejected exemption"
      end
    end
  end
end
