module Admin
  module EnrollmentExemptions
    class DeregisterForm < BaseChangeStateForm

      def params_key
        :admin_enrollment_exemptions_deregister
      end

      def self.reasons
        @reasons ||= FloodRiskEngine::EnrollmentExemption.deregister_reasons.keys
      end

      def self.locale_key
        "admin.enrollment_exemptions.deregister.new"
      end

      property :deregister_reason
      property :comment, virtual: true

      validates(
        :deregister_reason,
        inclusion: {
          in: reasons.collect(&:to_s),
          message: t(
            ".errors.deregister_reason.inclusion",
            reasons: reasons.collect { |r| "'#{r.to_s.humanize}'" }.join(
              t(".errors.deregister_reason.last_word_connector")
            )
          )
        }
      )

      validates(
        :comment,
        presence: { message: t(".errors.comment.blank") },
        length: {
          maximum: COMMENT_MAX_LENGTH,
          message: t(".errors.comment.too_long", max: COMMENT_MAX_LENGTH)
        }
      )

      def save
        model.status = :deregistered
        create_comment
        super
      end

      def reasons
        self.class.reasons
      end

      def create_comment
        super "Deregistered exemption with #{deregister_reason.to_s.humanize}"
      end

    end
  end
end
