module Admin
  module EnrollmentExemptions
    class ChangeStatusBaseController < ApplicationController
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

      def authorize_action
        raise "Instance method `#{__method__}` must be defined in #{self.class.name}"
      end

      def form_class
        raise "Instance method `#{__method__}` must be defined in #{self.class.name}"
      end

      def enrollment_exemption
        @enrollment_exemption ||= FloodRiskEngine::EnrollmentExemption.find(params[:enrollment_exemption_id])
      end
      delegate :enrollment, to: :enrollment_exemption

      def form
        @form ||= form_class.new(enrollment_exemption, current_user)
      end
      helper_method :form

      def save_form!
        return false unless form.validate(params)
        form.save
      end
    end
  end
end
