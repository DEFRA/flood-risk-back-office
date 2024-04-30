# frozen_string_literal: true

desc "Update water management area for all enrollments"
task refresh_water_management_areas: :environment do
  run_for = FloodRiskBackOffice::Application.config.area_lookup_run_for.to_i
  run_until = run_for.minutes.from_now

  updated_count = 0
  FloodRiskEngine::Location.find_each do |location|
    easting = location.easting&.to_i
    northing = location.northing&.to_i

    unless easting.is_a?(Integer) && northing.is_a?(Integer)
      puts "Invalid easting/northing (#{easting}/#{northing}), enrollment number: #{enrollment_number(location)}"
      next
    end

    begin
      FloodRiskEngine::UpdateWaterManagementAreaJob.perform_now(location)
      updated_count += 1

      break if Time.zone.now > run_until
    rescue StandardError => e
      puts "Error looking up water management area for location with easting/northing " \
           "#{easting}/#{northing}, enrollment number: #{enrollment_number(location)}: #{e}"
    end
  end

  unless Rails.env.test?
    puts "refresh_water_management_areas task updated #{updated_count} of #{FloodRiskEngine::Location.count} locations"
  end
end

def enrollment_number(location)
  location.locatable&.reference_number&.number
end
