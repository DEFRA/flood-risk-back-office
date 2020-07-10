require "defra_ruby/aws"

DefraRuby::Aws.configure do |c|
  epr_bucket = {
    name: ENV["AWS_DAILY_EXPORT_BUCKET"],
    region: ENV["AWS_REGION"],
    credentials: {
      access_key_id: ENV["AWS_DAILY_EXPORT_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_DAILY_EXPORT_SECRET_ACCESS_KEY"]
    },
    encrypt_with_kms: ENV["AWS_ENCRYPT_WITH_KMS"]
  }

  c.buckets = [epr_bucket]
end
