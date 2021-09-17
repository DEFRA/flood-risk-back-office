module Admin
  class EnrollmentExemptionsController < ApplicationController

    def index
      authorize EnrollmentExemption
      search_form = SearchForm.new(params)
      render :index, locals: {
        form: search_form,
        enrollment_exemptions: enrollment_exemptions_for(search_form)
      }
    end

    def show
      enrollment_exemption = load_and_authorise_enrollment_exemption
      presenter = EnrollmentExemptionPresenter.new(enrollment_exemption, view_context)

      render :show, locals: { presenter: presenter }
    end

    private

    def enrollment_exemptions_for(search_form)
      return [] unless params[:search]

      enrollment_exemptions = EnrollmentExemptionSearchQuery.call(search_form)
      EnrollmentExemptionsPresenter.new(enrollment_exemptions, view_context)
    end

    def load_and_authorise_enrollment_exemption
      enrollment_exemption = EnrollmentExemption.find(params[:id])
      authorize enrollment_exemption
      enrollment_exemption
    end
  end
end
