require "rails_helper"

RSpec.describe "Lookups task" do
  describe "lookups:update:missing_area" do
    include_context "rake"

    let(:location_to_update) { create(:location) }
    let(:location_not_to_update) { create(:location, grid_reference: nil) }
    let(:run_for) { 10 }

    before do
      location_to_update
      location_not_to_update

      allow(FloodRiskEngine::UpdateWaterManagementAreaJob).to receive(:perform_now).with(anything)
    end

    it "updates area info for a location without an area" do
      expect(FloodRiskEngine::UpdateWaterManagementAreaJob).to receive(:perform_now).with(location_to_update)
      expect(FloodRiskEngine::UpdateWaterManagementAreaJob).not_to receive(:perform_now).with(location_not_to_update)

      subject.invoke
    end
  end
end
