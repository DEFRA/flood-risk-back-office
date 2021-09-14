module Enrollments
  class CorrespondenceContactsController < ApplicationController
    before_action :load_defaults

    def edit
      authorize CorrespondenceContact
    end

    def update
      authorize CorrespondenceContact

      if @correspondence_contact.update(correspondence_contact_params)
        redirect_to admin_enrollment_exemption_path(@enrollment_exemption)
      else
        render :edit
      end
    end

    protected

    def load_defaults
      @correspondence_contact = CorrespondenceContact.find(params[:id])
      @enrollment = FloodRiskEngine::Enrollment.find_by(token: params[:enrollment_id])
      @enrollment_exemption = @enrollment.enrollment_exemptions.first
    end

    def correspondence_contact_params
      params.require(:correspondence_contact).permit(
        :full_name,
        :position,
        :telephone_number,
        :email_address
      )
    end
  end
end
