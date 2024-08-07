# frozen_string_literal: true

require_relative "../concerns/can_load_file_to_aws"

module Reports
  class EprExportService < ::FloodRiskEngine::BaseService
    include CanLoadFileToAws

    def run
      populate_temp_file

      options = { s3_directory: "EPR" }

      load_file_to_aws_bucket(options)
    rescue StandardError => e
      Airbrake.notify e, file_name: file_name
      Rails.logger.error "Generate EPR export csv error for #{file_name}:\n#{e}"
    ensure
      FileUtils.rm_rf(file_path)
    end

    private

    def populate_temp_file
      epr_report(file_path)
    end

    def file_path
      @file_path ||= Rails.root.join("tmp/#{file_name}.csv")
    end

    def file_name
      @file_name ||= FloodRiskBackOffice::Application.config.epr_export_filename
    end

    def epr_report(file_path)
      EprSerializer.new.to_csv(file_path)
    end

    def bucket_name
      @bucket_name ||= FloodRiskBackOffice::Application.config.epr_exports_bucket_name
    end
  end
end
