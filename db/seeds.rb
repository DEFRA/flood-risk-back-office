# frozen_string_literal: true

FloodRiskEngine::Engine.load_seed

def create_user(email, role)
  user = User.create!(
    email:,
    password: ENV.fetch("DEFAULT_PASSWORD", "Secret123")
  )
  Rolify.resource_types << "User" unless Rolify.resource_types.include?("User")
  Role.create!(name: role)
  user.add_role role
end

def seed_users
  seeds = JSON.parse(File.read("#{Rails.root}/db/seeds/users.json"))
  users = seeds["users"]

  users.each do |user|
    next if User.where(email: user["email"]).exists?

    create_user(user["email"], user["role"])
  end
end

# Only seed if not running in production or we specifically require it, eg. for Heroku
seed_users if !Rails.env.production? || ENV["ALLOW_SEED"]
