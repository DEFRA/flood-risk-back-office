# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

log_output_path = ENV["EXPORT_SERVICE_CRON_LOG_OUTPUT_PATH"] || "/srv/ruby/flood-risk-activity-exemption-back-office/shared/log/"
set :output, File.join(log_output_path, "whenever_cron.log")
set :job_template, "/bin/bash -l -c 'eval \"$(rbenv init -)\" && :job'"

# Only one of the AWS app servers has a role of "db"
# see https://gitlab-dev.aws-int.defra.cloud/open/rails-deployment/blob/master/config/deploy.rb#L69
# so only creating cronjobs on that server, otherwise all jobs would be duplicated everyday!

# This will run daily and update EA areas for addresses with x and y but without Area.
every :day, at: (ENV["AREA_LOOKUP"] || "1:05"), roles: [:db] do
  rake "lookups:update:missing_area"
end

# This is the EPR export job. When run this will create a single CSV file of all
# active exemptions and put this into an AWS S3 bucket from which the company
# that provides and maintains the Electronis Public Register will grab it
every :day, at: (ENV["EXPORT_SERVICE_EPR_EXPORT_TIME"] || "21:05"), roles: [:db] do
  rake "reports:export:epr"
end

