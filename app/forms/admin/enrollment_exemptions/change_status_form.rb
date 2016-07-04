module Admin
  module EnrollmentExemptions
    class ChangeStatusForm < BaseChangeStateForm

      def params_key
        :admin_enrollment_exemptions_change_status
      end

      def self.statuses
        @statuses ||= FloodRiskEngine::EnrollmentExemption.statuses.keys
      end

      def self.locale_key
        "admin.enrollment_exemptions.change_status.new"
      end

      property :status
      property :comment, virtual: true

      validates(
        :status,
        inclusion: {
          in: statuses.collect(&:to_s),
          message: t(
            ".errors.status.inclusion",
            statuses: statuses.collect(&:humanize).join(
              t(".errors.status.last_word_connector")
            )
          )
        }
      )

      validates(
        :comment,
        length: {
          maximum: COMMENT_MAX_LENGTH,
          message: t(".errors.comment.too_long", max: COMMENT_MAX_LENGTH)
        }
      )

      def save
        create_comment unless comment.blank?
        super
      end

      def statuses
        self.class.statuses
      end

      def create_comment
        super "Change exemption from #{enrollment_exemption.status} to #{status}"
      end
    end
  end
end
