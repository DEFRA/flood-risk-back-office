# frozen_string_literal: true

require "defra_ruby/aws"

secrets = FloodRiskBackOffice::Application.secrets

DefraRuby::Aws.configure do |c|
  epr_exports_bucket = {
    name: FloodRiskBackOffice::Application.config.epr_exports_bucket_name,
    region: secrets.aws_region,
    credentials: {
      access_key_id: secrets.aws_daily_export_access_key_id,
      secret_access_key: secrets.aws_daily_export_secret_access_key
    }
  }

  manual_enrollments_export_bucket = {
    name: FloodRiskBackOffice::Application.config.enrollment_exports_bucket_name,
    region: secrets.aws_region,
    credentials: {
      access_key_id: secrets.aws_manual_export_access_key_id,
      secret_access_key: secrets.aws_manual_export_secret_access_key
    }
  }

  c.buckets = [epr_exports_bucket, manual_enrollments_export_bucket]
end
