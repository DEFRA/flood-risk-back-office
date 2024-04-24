require "rails_helper"
require "zip"

RSpec.describe WaterManagementAreaDataLoadService, type: :service do
  describe ".run" do

    existing_code = "DVNCWL"
    existing_area_id = 27
    existing_area_name = "an area name"
    existing_long_name = "a long name"
    existing_short_name = "a short name"

    # The service is heavy so run it once only
    before(:all) do # rubocop:disable RSpec/BeforeAfterAll
      FloodRiskEngine::WaterManagementArea.create!(
        area_id: 1,
        code: existing_code,
        area_name: existing_area_name,
        long_name: existing_long_name,
        short_name: existing_short_name,
        area: nil
      )

      described_class.run
    end

    let(:existing_area) { FloodRiskEngine::WaterManagementArea.first }

    it { expect(FloodRiskEngine::WaterManagementArea.count).to eq(16) }

    it "sets the expected attributes" do
      area = FloodRiskEngine::WaterManagementArea.first
      aggregate_failures do
        expect(area.area_id).to be_present
        expect(area.code).to be_present
        expect(area.long_name).to be_present
        expect(area.short_name).to be_present
        expect(area.area_name).to be_present
      end
    end

    it "does not update the code" do
      expect(existing_area.reload.code).to eq existing_code
    end

    it "does not update the area_id" do
      expect(existing_area.reload.area_id).to eq existing_area_id
    end

    it "saves the area geometry" do
      expect(existing_area.reload.area).not_to be_nil
    end

    it "updates the area name" do
      expect(existing_area.reload.area_name).not_to eq existing_area_name
    end

    it "updates the long name" do
      expect(existing_area.reload.long_name).not_to eq existing_long_name
    end

    it "updates the short name" do
      expect(existing_area.reload.short_name).not_to eq existing_short_name
    end
  end
end
