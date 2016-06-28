module Admin
  module EnrollmentExemptions
    class DeregisterController < ApplicationController
      before_action :authorize_action

      def new
        form
      end

      def create
        if save_form!
          redirect_to [:admin, enrollment_exemption]
        else
          render :new
        end
      end

      private

      def enrollment_exemption
        @enrollment_exemption ||= FloodRiskEngine::EnrollmentExemption.find(params[:enrollment_exemption_id])
      end
      delegate :enrollment, to: :enrollment_exemption

      def authorize_action
        authorize enrollment, :deregister?
      end

      def form
        @form ||= DeregisterForm.new(enrollment_exemption, current_user)
      end
      helper_method :form

      def save_form!
        return false unless form.validate(params)
        form.save
      end

    end
  end
end
