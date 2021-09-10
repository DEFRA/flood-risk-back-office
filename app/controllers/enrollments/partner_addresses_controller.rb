module Enrollments
  class PartnerAddressesController < ApplicationController
    before_action :load_defaults

    def edit
      authorize PartnerAddress
    end

    def update
      authorize PartnerAddress

      if @partner_address.update(partner_address_params)
        redirect_to admin_enrollment_exemption_path(@enrollment_exemption)
      else
        render :edit
      end
    end

    protected

    def load_defaults
      @partner_address = PartnerAddress.find_by(token: params[:id])
      @enrollment = FloodRiskEngine::Enrollment.find_by(token: params[:enrollment_id])
      @enrollment_exemption = @enrollment.enrollment_exemptions.first
    end

    def partner_address_params
      params.require(:partner_address).permit(
        :full_name, :premises, :street_address, :locality, :city, :postcode
      )
    end
  end
end
