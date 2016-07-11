module Admin
  module EnrollmentExemptions
    module Concerns
      module CommentableForm

        include Reform::Form::Module

        extend ActiveSupport::Concern

        COMMENT_MAX_LENGTH = 500

        included do
          property :comment, virtual: true

          validates(
            :comment,
            presence: { message: t(".errors.comment.blank") },
            length: {
              maximum: COMMENT_MAX_LENGTH,
              message: t(".errors.comment.too_long", max: COMMENT_MAX_LENGTH)
            }
          )
        end

        def comment_max_length
          COMMENT_MAX_LENGTH
        end

        def create_comment(event, user)
          enrollment_exemption.comments.create(
            content: comment,
            user: user,
            event: event
          )
        end

      end
    end
  end
end
