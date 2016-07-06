module Admin
  module EnrollmentExemptions
    class ResendApprovalEmailForm < BaseChangeStateForm

      def params_key
        :admin_enrollment_exemptions_resend_approval_email
      end

      def self.locale_key
        "admin.enrollment_exemptions.resend_approval_email.new"
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

      delegate :asset_found, :salmonid_river_found, to: :enrollment_exemption

      def save
        create_comment
        SendRegistrationApprovedEmail.for enrollment_exemption
      end

      def create_comment
        super "Reissued registration approved email"
      end
    end
  end
end
