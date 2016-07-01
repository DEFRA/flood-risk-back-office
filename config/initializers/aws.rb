secrets = Rails.application.secrets

Aws.config.update({
  region: secrets.aws_region,
  credentials: Aws::Credentials.new(secrets.aws_access_key_id, secrets.aws_secret_access_key)
})
