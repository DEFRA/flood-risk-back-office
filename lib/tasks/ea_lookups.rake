# frozen_string_literal: true

namespace :ea_lookups do
  namespace :update do
    desc "Populate EA Area information in all FloodRiskEngine::Location objects missing it."
    task area: :environment do
      run_for = FloodRiskBackOffice::Application.config.ea_area_lookup_run_for.to_i
      run_until = run_for.minutes.from_now
      locations_scope = FloodRiskEngine::Location.missing_ea_area.with_easting_and_northing

      locations_scope.find_each do |location|
        break if Time.now > run_until

        FloodRiskEngine::UpdateWaterManagementAreaJob.perform_now(location)
      end

      Airbrake.close
    end
  end
end
