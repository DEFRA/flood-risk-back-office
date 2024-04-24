require "rails_helper"

RSpec.describe "Refresh water management areas for a range of registrations" do
  describe "refresh_water_management_areas", type: :rake do
    subject(:rake_task) { Rake::Task["refresh_water_management_areas"] }

    include_context "rake"

    before { create_list(:location, 3) }

    it "calls the update area job for each location" do
      expect(FloodRiskEngine::UpdateWaterManagementAreaJob).to receive(:perform_now).exactly(3).times

      rake_task.invoke
    end
  end
end
