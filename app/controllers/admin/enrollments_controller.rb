module Admin
  class EnrollmentsController < ApplicationController

    def new
      authorize FloodRiskEngine::Enrollment

      redirect_to flood_risk_engine.new_start_form_path
    end
  end
end
