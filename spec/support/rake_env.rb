# frozen_string_literal: true

# See also spec/shared_contexts/rake.rb
RSpec.configure do |config|
  config.before(:suite) do
    Rake.application = Rake::Application.new
    Rails.application.load_tasks

    Rake::Task.define_task(:environment)
  end

  config.before(:each, type: :task) do
    DatabaseCleaner.strategy = :deletion
  end

  config.after(type: :task) do
    DatabaseCleaner.clean_with(:deletion)
  end
end
