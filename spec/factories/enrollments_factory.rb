FactoryGirl.define do
  factory :base_back_office_enrollment, parent: :enrollment do
    after(:create) do |object|
      object.exemption_location = build(:location, description: "#{FFaker::Address.neighborhood}, near river.")
      object.correspondence_contact = build(:flood_risk_engine_contact, email_address: Faker::Internet.email)

      object.save
    end

    trait :with_secondary_contact do
      association :secondary_contact, factory: :contact
    end

    step :confirmation
  end

  # Base class for BO Enrollment with a random exemption, status, and valid_from selected for EnrollmentExemption

  factory :confirmed_random_pending, parent: :base_back_office_enrollment do
    after(:create) do |object|
      exemption = FloodRiskEngine::Exemption.offset(rand(FloodRiskEngine::Exemption.count)).first || create(:exemption)

      object.submit

      object.enrollment_exemptions.build(
        exemption: exemption,
        status: %w(building pending being_processed).sample,
        valid_from: (Date.current - rand(7).days)
      )
    end

    trait :with_secondary_contact do
      association :secondary_contact, factory: :contact
    end
  end

  factory :confirmed, parent: :confirmed_random_pending, traits: [:with_limited_company, :with_secondary_contact]

  factory :confirmed_no_secondary_contact, parent: :confirmed_random_pending, traits: [:with_limited_company]
end
