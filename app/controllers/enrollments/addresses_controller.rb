module Enrollments
  class AddressesController < ApplicationController
    before_action :load_defaults

    def edit
      authorize Address
    end

    def update
      authorize Address

      if @address.update(address_params)
        redirect_to admin_enrollment_exemption_path(@enrollment_exemption)
      else
        render :edit
      end
    end

    protected

    def load_defaults
      @address = Address.find_by(token: params[:id])
      @enrollment = FloodRiskEngine::Enrollment.find_by(token: params[:enrollment_id])
      @enrollment_exemption = @enrollment.enrollment_exemptions.first
    end

    def address_params
      params.require(:address).permit(
        :premises, :street_address, :locality, :city, :postcode
      )
    end
  end
end
