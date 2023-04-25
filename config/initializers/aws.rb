secrets = Rails.application.secrets

Aws.config.update({
  region: secrets.aws_region,
  credentials: Aws::Credentials.new(secrets.fra_aws_access_key_id, secrets.fra_aws_secret_access_key)
})
