Rails.logger.info "BO:SEED MSG: Seeding users..."

User.destroy_all

%w(
  pollyjjones@gmail.com
  glancyea@gmail.com
  alan.cruikshanks@environment-agency.gov.uk
  paula.french@environment-agency.gov.uk
  johnathan.austin@environment-agency.gov.uk
  tim.stone.ea@gmail.com
  tim.crowe.ea@gmail.com
  robnichols.ea@gmail.com
  tomstatter@gmail.com
).each do |email|
  user = User.create!(email: email, password: "Abcde12345")
  user.add_role :system
end

Rails.logger.info "BO:SEED MSG: There are now #{User.count} rows in the users table"
