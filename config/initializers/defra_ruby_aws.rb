require "defra_ruby/aws"

# secrets = Rails.application.secrets

# DefraRuby::Aws.configure do |c|
#   epr_bucket = {
#     name: ENV["AWS_DAILY_EXPORT_BUCKET"],
#     region: ENV["AWS_REGION"],
#     credentials: {
#       access_key_id: ENV["AWS_DAILY_EXPORT_ACCESS_KEY_ID"],
#       secret_access_key: ENV["AWS_DAILY_EXPORT_SECRET_ACCESS_KEY"]
#     }
#   }

#   c.buckets = [epr_bucket]
# end
