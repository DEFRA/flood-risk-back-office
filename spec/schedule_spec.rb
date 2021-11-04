# frozen_string_literal: true

require "rails_helper"
require "whenever/test"
require "open3"

# This allows us to ensure that the schedules we have declared in whenever's
# (https://github.com/javan/whenever) config/schedule.rb are valid.
# The hope is this saves us from only being able to confirm if something will
# work by actually running the deployment and seeing if it breaks (or not)
# See https://github.com/rafaelsales/whenever-test for more details

RSpec.describe "Whenever schedule" do
  let(:schedule) { Whenever::Test::Schedule.new(file: "config/schedule.rb") }

  it "makes sure 'rake' statements exist" do
    rake_jobs = schedule.jobs[:rake]
    expect(rake_jobs.count).to eq(3)
  end

  it "picks up the area lookup run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "lookups:update:missing_area" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("1:05")
  end

  it "picks up the EPR export run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "reports:export:epr" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("21:05")
  end

  it "picks up the transient registration cleanup execution run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "cleanup:transient_registrations" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("00:35")
  end

  it "can determine the configured cron log output path" do
    expected_output_file = File.join("/srv/ruby/flood-risk-activity-exemption-back-office/shared/log/", "whenever_cron.log")
    expect(schedule.sets[:output]).to eq(expected_output_file)
  end

  it "allows the `whenever` command to be called without raising an error" do
    Open3.popen3("bundle", "exec", "whenever") do |_, stdout, stderr, wait_thr|
      expect(stdout.read).to_not be_empty
      expect(stderr.read).to be_empty
      expect(wait_thr.value.success?).to eq(true)
    end
  end
end
