
module Admin
  module EnrollmentExemptions
    class DeregisterForm < BaseChangeStateForm

      def params_key
        :admin_enrollment_exemptions_deregister
      end

      def self.statuses
        @statuses ||= FloodRiskEngine::EnrollmentExemption.statuses.slice(
          "expired", "withdrawn"
        ).keys
      end

      def self.locale_key
        "admin.enrollment_exemptions.deregister.new"
      end

      property :status
      property :comment, virtual: true

      validates(
        :status,
        inclusion: {
          in: statuses.collect(&:to_s),
          message: t(
            ".errors.status.inclusion",
            statuses: statuses.join(
              t(".errors.status.last_word_connector")
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
        create_comment
        super
      end

      def statuses
        self.class.statuses
      end

      def create_comment
        super "Deregistered exemption with #{status}"
      end

    end
  end
end
