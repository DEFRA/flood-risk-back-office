module Enrollments
  class OrganisationsController < ApplicationController
    before_action :load_defaults

    def edit
      authorize Organisation
    end

    def update
      authorize Organisation

      if @organisation.update(organisation_params)
        redirect_to admin_enrollment_exemption_path(@enrollment_exemption)
      else
        render :edit
      end
    end

    protected

    def load_defaults
      @organisation = Organisation.find(params[:id])
      @enrollment = FloodRiskEngine::Enrollment.find_by(token: params[:enrollment_id]) ||
                    FloodRiskEngine::Enrollment.find(params[:enrollment_id])
      @enrollment_exemption = @enrollment.enrollment_exemptions.first
    end

    def organisation_params
      params.require(:organisation).permit(:name)
    end
  end
end
