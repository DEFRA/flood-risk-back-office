module Admin
  class EnrollmentExemptionsController < ApplicationController

    def index
      authorize FloodRiskEngine::EnrollmentExemption
      search_form = SearchForm.new(params)
      enrollment_exemptions = SearchQuery.call(search_form)
      presenter = EnrollmentExemptionsPresenter.new(enrollment_exemptions, view_context)

      render :index, locals: {
        enrollment_exemptions: presenter
      }
    end

    def show
      enrollment_exemption = load_and_authorise_enrollment_exemption

      presenter = EnrollmentExemptionPresenter.new(enrollment_exemption, view_context)

      form = EnrollmentExemptionForm.new(enrollment_exemption)

      render :show, locals: {
        presenter: presenter,
        form: form
      }
    end

    private

    def load_and_authorise_enrollment_exemption
      enrollment_exemption = FloodRiskEngine::EnrollmentExemption.find(params[:id])
      authorize enrollment_exemption
      enrollment_exemption
    end
  end
end
