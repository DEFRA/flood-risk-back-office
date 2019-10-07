require "rails_helper"

RSpec.describe "Lookups task" do
  describe "lookups:update:missing_area" do
    include_context "rake"

    let(:run_for) { 10 }

    before do
      expect(FloodRiskBackOffice::Application.config).to receive(:area_lookup_run_for).and_return(run_for)
    end

    it "update area info into locations missing it" do
      location_to_update = create(:location)
      area = double(:area, code: "123", area_id: 123, area_name: "Foo", short_name: "Bar", long_name: "Baz")
      result = double(:result, areas: [area], successful?: true)
      water_management_area_count = FloodRiskEngine::WaterManagementArea.count + 1

      expect(DefraRuby::Area::WaterManagementAreaService).to receive(:run).and_return(result)

      subject.invoke

      expect(FloodRiskEngine::WaterManagementArea.count).to eq(water_management_area_count)

      new_water_management_area = FloodRiskEngine::WaterManagementArea.last

      expect(location_to_update.reload.water_management_area).to eq(new_water_management_area)
    end
  end
end
