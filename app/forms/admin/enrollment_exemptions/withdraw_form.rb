module Admin
  module EnrollmentExemptions
    class WithdrawForm < BaseChangeStateForm

      def params_key
        :admin_enrollment_exemptions_withdraw
      end

      def self.locale_key
        "admin.enrollment_exemptions.withdraw.new"
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

      def save
        super
        create_comment
        enrollment_exemption.withdrawn!
      end

      def create_comment
        super "Withdrawn exemption"
      end
    end
  end
end
