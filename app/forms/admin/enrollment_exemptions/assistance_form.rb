module Admin
  module EnrollmentExemptions
    class AssistanceForm < Admin::BaseForm
      attribute :mode, String
      attribute :comment, String

      validates :mode, presence: true
      validates :comment, length: { maximum: 500 }

      def mode=(value)
        @mode = ActiveSupport::StringInquirer.new(value || "")
      end

      def save(enrollment_exemption, user)
        valid? && persist(enrollment_exemption, user)
      end

      private

      def persist(enrollment_exemption, user)
        # We save mode as nil if 'unassisted' was selected in a dropdown
        enrollment_exemption.assistance_mode = set_mode_to_nil? ? nil : mode
        enrollment_exemption.assistance_comment = comment
        enrollment_exemption.updated_by = user.email
        enrollment_exemption.save
      end

      def set_mode_to_nil?
        mode.unassisted? || mode.blank?
      end
    end
  end
end