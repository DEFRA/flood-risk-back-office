module Admin
  module EnrollmentExemptions
    class AssistanceController < ApplicationController
      def edit
        load_and_authorise_enrollment_exemption
        attrs = { mode: @enrollment_exemption.assistance_mode, comment: @enrollment_exemption.assistance_comment}
        @form = AssistanceForm.new(attrs)
      end

      def update
        load_and_authorise_enrollment_exemption
        @form = AssistanceForm.new(assistance_params)
        if @form.save(@enrollment_exemption, current_user)
          notice = FlashUpdateI18nNotice.new(@enrollment_exemption.assistance_mode)
          redirect_to [:admin, @enrollment_exemption], notice: t(notice.key, notice.options)
        else
          render :edit
        end
      end

      private

      def load_and_authorise_enrollment_exemption
        @enrollment_exemption = FloodRiskEngine::EnrollmentExemption.find(params[:id])
        authorize enrollment_exemption, :edit?
      end

      def assistance_params
        params
          .require(:admin_enrollment_assistance_form)
          .permit(:mode, :comment)
      end

      #
      # Helper class for building a flash notice when details are updated.
      #
      class FlashUpdateI18nNotice
        attr_reader :assistance_mode

        def initialize(assistance_mode)
          @assistance_mode = assistance_mode
        end

        def key
          unassisted? ? ".notice" : ".notice_with_mode"
        end

        def options
          { mode: assistance_mode_text } unless unassisted?
        end

        private

        def assistance_mode_text
          I18n.t(".#{assistance_mode}", scope: "assistance_modes")
        end

        def unassisted?
          assistance_mode.blank? || assistance_mode == "unassisted"
        end
      end
    end
  end
end
