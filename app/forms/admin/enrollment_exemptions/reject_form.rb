
module Admin
  module EnrollmentExemptions
    class RejectForm < BaseForm
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

      property :comment, virtual: true

      def save
        create_comment
        super
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
