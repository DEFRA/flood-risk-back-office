# frozen_string_literal: true

namespace :lookups do
  namespace :update do
    desc "Populate the water management area in all FloodRiskEngine::Location objects missing it."
    task missing_area: :environment do
      run_for = FloodRiskBackOffice::Application.config.area_lookup_run_for.to_i
      run_until = run_for.minutes.from_now
      locations_scope = FloodRiskEngine::Location.missing_area.with_easting_and_northing

      locations_scope.find_each do |location|
        break if Time.zone.now > run_until

        FloodRiskEngine::UpdateWaterManagementAreaJob.perform_now(location)
      end
    end
  end
end
