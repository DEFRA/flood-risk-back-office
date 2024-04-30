require "rails_helper"

RSpec.describe "Refresh water management areas for a range of registrations" do
  describe "refresh_water_management_areas", type: :rake do
    subject(:rake_task) { Rake::Task["refresh_water_management_areas"] }

    before {
      rake_task.reenable
      allow($stderr).to receive(:puts)

      create_list(:location, 3)
    }

    it "calls the update area job for each location" do
      expect(FloodRiskEngine::UpdateWaterManagementAreaJob).to receive(:perform_now).exactly(3).times

      rake_task.invoke
    end

    context "with nil easting/northing values" do
      before { FloodRiskEngine::Location.first.update(easting: nil) }

      it { expect { rake_task.invoke }.not_to raise_error }

      it do
        expect($stderr).to receive(:puts).with(a_string_including("Invalid easting/northing"))

        rake_task.invoke
      end
    end

    context "when the update job raises an exception" do
      before do
        allow($stderr).to receive(:puts)

        allow(FloodRiskEngine::UpdateWaterManagementAreaJob).to receive(:perform_now).and_raise(StandardError)
      end

      it { expect { rake_task.invoke }.not_to raise_error }

      it do
        expect($stderr).to receive(:puts).with(a_string_including("Error looking up water management area"))
                                         .exactly(3).times

        rake_task.invoke
      end
    end
  end
end
