FactoryBot.define do
  factory :enrollment_export do
    state { "queued" }
    created_by { Faker::Internet.email }

    trait :with_dates do
      from_date { 1.year.ago }
      to_date { Date.current }
    end

    trait :with_file_name do
      after(:build, &:populate_file_name)
    end

    trait :completed do
      with_dates
      record_count { 5 }
      state { :completed }

      after(:build, &:populate_file_name)
    end
  end
end
