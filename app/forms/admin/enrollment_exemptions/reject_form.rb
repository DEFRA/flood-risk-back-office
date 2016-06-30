
module Admin
  module EnrollmentExemptions
    class RejectForm < BaseForm

      COMMENT_MAX_LENGTH = 500

      attr_reader :user

      def initialize(enrollment_exemption, user)
        @user = user
        super(enrollment_exemption)
      end
      alias enrollment_exemption model
      delegate :enrollment, :exemption, to: :enrollment_exemption
      delegate :reference_number, to: :enrollment

      def params_key
        :admin_enrollment_exemptions_reject
      end

      def self.locale_key
        "admin.enrollment_exemptions.reject.new"
      end

      property :comment, virtual: true
      validates(
        :comment,
        length: {
          maximum: COMMENT_MAX_LENGTH,
          message: t(".errors.comment.too_long", max: COMMENT_MAX_LENGTH)
        }
      )

      def comment_max_length
        COMMENT_MAX_LENGTH
      end

      def save
        create_comment if comment.present?
        enrollment_exemption.rejected!
        SendRegistrationRejectedEmail.for enrollment_exemption
      end

      def create_comment
        enrollment_exemption.comments.create(
          content: comment,
          user: user,
          event: "Reject exemption"
        )
      end
    end
  end
end
