# See also spec/support/rake_env.rb
require "rake"

RSpec.shared_context "rake" do
  subject { Rake.application[task_name] }

  let(:task_name) { self.class.description }
  let(:task_path) { "lib/tasks/#{task_name.split(':').first}" }
end
