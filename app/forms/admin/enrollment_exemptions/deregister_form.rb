
module Admin
  module EnrollmentExemptions
    class DeregisterForm < BaseForm

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
        :admin_enrollment_exemptions_deregister
      end

      def self.statuses
        @statuses ||= FloodRiskEngine::EnrollmentExemption.statuses.slice(
          "expired", "withdrawn"
        ).keys
      end

      def self.t(locale, args = {})
        I18n.t locale, args.merge(scope: locale_key)
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

      def comment_max_length
        COMMENT_MAX_LENGTH
      end

      def statuses
        self.class.statuses
      end

      include StatusTag

      def status_tag
        super(enrollment_exemption.status, status_label)
      end

      def status_label
        I18n.t(status, scope: "admin.status_label") if status.present?
      end

      def create_comment
        enrollment_exemption.comments.create(
          content: comment,
          user: user,
          event: "Deregistered exemption with #{status}"
        )
      end

    end
  end
end
