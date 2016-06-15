FactoryGirl.define do
  factory :enrollment_export do
    state "queued"
    created_by { Faker::Internet.email }

    trait :with_dates do
      from_date 10.days.ago
      to_date 5.days.ago
    end

    trait :completed do
      from_date 10.days.ago
      to_date 5.days.ago
      record_count 5
      state :completed

      after(:build, &:populate_file_name)
    end
  end
end
