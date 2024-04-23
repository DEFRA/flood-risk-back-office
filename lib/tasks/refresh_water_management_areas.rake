# frozen_string_literal: true

desc "Update water management area for all enrollments"
task refresh_water_management_areas: :environment do

  run_for = FloodRiskBackOffice::Application.config.area_lookup_run_for.to_i
  run_until = run_for.minutes.from_now

  FloodRiskEngine::Location.find_each do |location|
    break if Time.zone.now > run_until

    FloodRiskEngine::UpdateWaterManagementAreaJob.perform_now(location)
  end
end
