RSpec.configure do |config|
  config.before :suite do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  config.before do |ex|
    # rubocop:disable Style/ConditionalAssignment
    if %i[feature query].include?(ex.metadata[:type])
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
    end
    # rubocop:enable Style/ConditionalAssignment

    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
