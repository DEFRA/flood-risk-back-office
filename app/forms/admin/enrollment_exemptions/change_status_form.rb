module Admin
  module EnrollmentExemptions
    class ChangeStatusForm < BaseForm
      require_relative "concerns/form_status_tag"
      include FormStatusTag

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
        :admin_enrollment_exemptions_change_status
      end

      def self.statuses
        @statuses ||= FloodRiskEngine::EnrollmentExemption.statuses.keys.reject do |status|
          statuses_to_exclude.include? status.to_s
        end
      end

      def self.statuses_to_exclude
        %w(approved rejected expired withdrawn)
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

      def comment_max_length
        COMMENT_MAX_LENGTH
      end

      def statuses
        self.class.statuses
      end

      def create_comment
        enrollment_exemption.comments.create(
          content: comment,
          user: user,
          event: "Change exemption from #{enrollment_exemption.status} to #{status}"
        )
      end
    end
  end
end
