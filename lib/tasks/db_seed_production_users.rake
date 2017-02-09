require "rake"

# rubocop:disable Metrics/BlockLength
namespace :db do
  desc "Seed production users"
  task seed_production_users: :environment do
    puts "## Seeding production users..."

    Rails.application.config.active_job.queue_adapter = :inline

    conn = ActiveRecord::Base.connection
    if conn.instance_values["config"][:adapter].in? %w(postgres postgis)
      conn.reset_pk_sequence! User.table_name
    end

    file = Rails.root.join("db", "seeds", "production_users.yml")
    role_emails = HashWithIndifferentAccess.new(YAML.load_file(file))

    %i(system super_agent admin_agent data_agent).each do |role|
      emails = role_emails[role].map(&:strip).map(&:downcase).uniq.compact

      puts "#" * 80
      puts "Seeding #{emails.count} #{role} users..."
      puts "#" * 80

      emails.each do |email|
        puts email
        next if User.where(email: email).exists?
        invited = User.invite! email: email do |user|
          user.skip_invitation = true if Rails.env.development?
          user.add_role role
        end
        unless invited.persisted?
          raise "Failed to save #{email}: #{invited.errors.full_messages.to_sentence}"
        end
      end
    end

    msg = "## Done. Seeded #{User.count} production users."
    puts msg
    Rails.logger.info msg
  end
end
# rubocop:enable Metrics/BlockLength
