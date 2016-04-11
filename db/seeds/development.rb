puts 'BO:SEED MSG: Seeding users...'

DigitalServicesCore::User.destroy_all

if ActiveRecord::Base.connection.instance_values['config'][:adapter].in? %w(postgres postgis)
  ActiveRecord::Base.connection.reset_pk_sequence! DigitalServicesCore::User.table_name
end

%w(pollyjjones@gmail.com
   alan.cruikshanks@environment-agency.gov.uk tim.stone.ea@gmail.com tomstatter@gmail.com
   paula.french@environment-agency.gov.uk ).each do |email|
  user = DigitalServicesCore::User.create!(email: email, password: 'Abcde12345')
  user.add_role :system
end

puts "BO:SEED MSG: There are now #{DigitalServicesCore::User.count} rows in the users table"
