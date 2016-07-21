RSpec.configure do |config|
  config.before :suite do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  config.before do |ex|
    # rubocop:disable Style/ConditionalAssignment
    if ex.metadata[:type] == :feature
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
    end

    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
