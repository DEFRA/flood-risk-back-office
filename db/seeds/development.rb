Rails.logger.info "BO:SEED MSG: Seeding users..."

User.destroy_all

# Generate a test account for each user role.
# See app/policies/application_policy.rb for listing of the supported roles
# N.B. This will create the accounts in a local development environment but
# won't create them when the application is deployed via Jenkins. This is
# because irrespective of the Jenkins environment being deployed to, we always
# deploy in production mode. Also you cannot simply run
# bundle exec rake db:seed RAILS_ENV=develop
# in those environments. We have different db config for each environment
# so setting that flag will mean rake is attempting to connect to db's that
# don't exist.
[:system, :super_agent, :admin_agent, :data_agent].each do |role_key|
  user = User.create!(
    email: "#{role_key}_user@example.gov.uk",
    password: "Abcde12345"
  )
  user.add_role role_key
end

Rails.logger.info "BO:SEED MSG: There are now #{User.count} rows in the users table"
