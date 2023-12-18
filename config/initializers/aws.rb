# frozen_string_literal: true

require "defra_ruby/aws"

secrets = Rails.application.secrets

DefraRuby::Aws.configure do |c|
  epr_reports_bucket = {
    name: FloodRiskBackOffice::Application.config.epr_reports_bucket_name,
    region: secrets.aws_region,
    credentials: {
      access_key_id: secrets.aws_access_key_id,
      secret_access_key: secrets.aws_secret_access_key
    }
  }

  c.buckets = [epr_reports_bucket]
end
