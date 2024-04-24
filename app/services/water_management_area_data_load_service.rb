# frozen_string_literal: true

require "zip"

class WaterManagementAreaDataLoadService < FloodRiskEngine::BaseService
  def run
    geo_json = read_areas_file
    features = RGeo::GeoJSON.decode(geo_json)

    ActiveRecord::Base.transaction do

      features.each do |feature|
        area_name = feature.properties["long_name"]

        attributes = {
          area_name:,
          area_id: feature.properties["identifier"],
          long_name: feature.properties["long_name"],
          short_name: feature.properties["short_name"],
          area: feature.geometry
        }

        area = FloodRiskEngine::WaterManagementArea.where(code: feature["code"]).first

        if area.present?
          area.update(attributes)
          puts "Updated Water Management Area \"#{area.code}\" (#{area.area_name})" unless Rails.env.test? # rubocop:disable Rails/Output
        else
          area = FloodRiskEngine::WaterManagementArea.create(attributes.merge(code: feature["code"]))
          puts "Created Water Management Area \"#{area.code}\" (#{area.area_name})" unless Rails.env.test? # rubocop:disable Rails/Output
        end
      end
    end
  end

  private

  def read_areas_file
    Zip::File.open(zipfile_path) do |zip_file|
      zip_file.glob(areas_filename)
              .first
              .get_input_stream
              .read
    end
  end

  def zipfile_path
    Rails.root.join("lib/fixtures/#{areas_filename}.zip")
  end

  def areas_filename
    "Administrative_Boundaries_Water_Management_Areas.json"
  end
end
