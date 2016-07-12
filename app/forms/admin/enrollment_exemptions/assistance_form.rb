module Admin
  module EnrollmentExemptions
    class AssistanceForm < Admin::BaseForm

      def initialize(enrollment_exemption, user)
        @user = user
        super(enrollment_exemption)
      end

      def params_key
        :admin_enrollment_exemptions_assistance
      end

      def self.locale_key
        "admin.enrollment_exemptions.assistance"
      end

      include Admin::EnrollmentExemptions::Concerns::CommentableForm

      alias enrollment_exemption model
      delegate :enrollment, to: :enrollment_exemption

      property :assistance_mode

      validates :assistance_mode, presence: { strict: true }

      validates :assistance_mode, inclusion: {
        allow_blank: true,
        in: FloodRiskEngine::EnrollmentExemption.assistance_modes.keys
      }

      def save
        super

        enrollment.update(updated_by_user_id: user.id) unless assistance_mode == "unassisted"

        mode = self.class.t("modes.#{assistance_mode}")
        create_comment("Updated Assistance Mode to #{mode}", user)
      end

      private

      attr_reader :user

    end
  end
end
