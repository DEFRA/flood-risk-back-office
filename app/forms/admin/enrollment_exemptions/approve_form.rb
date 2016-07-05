module Admin
  module EnrollmentExemptions
    class ApproveForm < BaseChangeStateForm

      def params_key
        :admin_enrollment_exemptions_approve
      end

      def self.locale_key
        "admin.enrollment_exemptions.approve.new"
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

      property :asset_found
      property :salmonid_river_found

      def save
        super
        create_comment
        enrollment_exemption.approved!
        SendRegistrationApprovedEmail.for enrollment_exemption
      end

      def create_comment
        super "Approved exemption"
      end
    end
  end
end
