require_dependency "reform"

module Admin
  module EnrollmentExemptions
    class BaseChangeStateForm < Reform::Form

      include ActionView::Helpers::TranslationHelper
      include ActiveModel::Validations
      include Reform::Form::ActiveModel

      include Concerns::FormStatusTag

      def self.t(locale, args = {})
        I18n.t locale, args.merge(scope: locale_key)
      end

      def self.locale_key
        raise "Class method `#{__method__}` must be defined in #{name}"
      end

      COMMENT_MAX_LENGTH = 500

      attr_reader :user

      def initialize(enrollment_exemption, user)
        @user = user
        super(enrollment_exemption)
      end
      alias enrollment_exemption model
      delegate :enrollment, :exemption, to: :enrollment_exemption
      delegate :reference_number, to: :enrollment

      def validate(params)
        super params.fetch(params_key, {})
      end

      def params_key
        raise "Instance method `#{__method__}` must be defined in #{self.class.name}"
      end

      def comment_max_length
        COMMENT_MAX_LENGTH
      end

      def organisation_name
        enrollment.try(:organisation).try(:name)
      end

      def create_comment(event)
        enrollment_exemption.comments.create(
          content: comment,
          user: user,
          event: event
        )
      end

      def logger
        Rails.logger
      end
    end
  end
end
