Rails.logger.info "BO:SEED MSG: Seeding users..."

User.destroy_all

# if ActiveRecord::Base.connection.instance_values["config"][:adapter].in? %w(postgres postgis)
#   ActiveRecord::Base.connection.reset_pk_sequence! User.table_name
# end

%w(
  pollyjjones@gmail.com
  alan.cruikshanks@environment-agency.gov.uk
  paula.french@environment-agency.gov.uk
  tim.stone.ea@gmail.com
  tim.crowe.ea@gmail.com
  rob.nichols.ea@gmail.com
  tomstatter@gmail.com
).each do |email|
  user = User.create!(email: email, password: "Abcde12345")
  user.add_role :system
end

Rails.logger.info "BO:SEED MSG: There are now #{User.count} rows in the users table"
