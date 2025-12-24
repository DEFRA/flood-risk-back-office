require "rails_helper"
require "zip"

RSpec.describe WaterManagementAreaDataLoadService, type: :service do
  describe ".run" do
    let(:existing_code) { "DVNCWL" }
    let(:existing_area_id) { 27 }
    let(:existing_area_name) { "an area name" }
    let(:existing_long_name) { "a long name" }
    let(:existing_short_name) { "a short name" }
    let(:existing_area) { FloodRiskEngine::WaterManagementArea.first }

    # The service is heavy so run it once only
    before(:all) do # rubocop:disable RSpec/BeforeAfterAll
      FloodRiskEngine::WaterManagementArea.create!(
        area_id: 1,
        code: "DVNCWL",
        area_name: "an area name",
        long_name: "a long name",
        short_name: "a short name",
        area: nil
      )

      described_class.run
    end

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
