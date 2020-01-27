# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe EprSerializer do
    describe "#to_csv" do
      let(:enrollment_exemption) { double(:enrollment_exemption) }
      let(:presenter) { double(:presenter) }

      before do
        allow(FloodRiskEngine::EnrollmentExemption).to receive(:approved).and_return([enrollment_exemption])
        allow(EprPresenter).to receive(:new).with(enrollment_exemption).and_return(presenter)
      end

      it "returns a string containing csv formatted data" do
        heading = '"Decision date","Exemption reference number","NGR","Water management area","Exemption code and description","Operator name"'
        data = '"accept_reject_decision_at","reference_number","grid_reference","water_management_area_long_name","code","organisation_details"'

        expect(presenter).to receive(:accept_reject_decision_at).and_return("accept_reject_decision_at")
        expect(presenter).to receive(:reference_number).and_return("reference_number")
        expect(presenter).to receive(:grid_reference).and_return("grid_reference")
        expect(presenter).to receive(:water_management_area_long_name).and_return("water_management_area_long_name")
        expect(presenter).to receive(:code).and_return("code")
        expect(presenter).to receive(:organisation_details).and_return("organisation_details")

        result = subject.to_csv

        expect(result).to include(heading)
        expect(result).to include(data)
      end
    end
  end
end
