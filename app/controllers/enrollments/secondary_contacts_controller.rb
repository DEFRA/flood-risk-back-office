module Enrollments
  class SecondaryContactsController < ApplicationController
    before_action :load_defaults

    def edit
      authorize SecondaryContact
    end

    def update
      authorize SecondaryContact

      if @secondary_contact.update(secondary_contact_params)
        redirect_to admin_enrollment_exemption_path(@enrollment_exemption)
      else
        render :edit
      end
    end

    protected

    def load_defaults
      @secondary_contact = SecondaryContact.find(params[:id])
      @enrollment = FloodRiskEngine::Enrollment.find_by(token: params[:enrollment_id])
      @enrollment_exemption = @enrollment.enrollment_exemptions.first
    end

    def secondary_contact_params
      params.require(:secondary_contact).permit(:email_address)
    end
  end
end
