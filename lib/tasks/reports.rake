# frozen_string_literal: true

namespace :reports do
  namespace :export do
    desc "Generate the EPR report and upload it to S3."
    task epr: :environment do
      Reports::EprExportService.run
    end
  end
end
