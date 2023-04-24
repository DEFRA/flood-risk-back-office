FactoryBot.define do
  factory :base_back_office_enrollment, parent: :enrollment do
    after(:create) do |object|
      object.exemption_location = build(:location, description: "#{Faker::Lorem.sentence}, near river.")
      object.correspondence_contact = build(:flood_risk_engine_contact, email_address: Faker::Internet.email)

      object.save
    end

    trait :with_secondary_contact do
      association :secondary_contact, factory: :contact
    end

    step { :confirmation }
  end

  # Base class for BO Enrollment with pending (pending or being_processed)
  # Exemption and random valid_from selected for EnrollmentExemption

  factory :confirmed_random_pending, parent: :base_back_office_enrollment do
    reference_number { FloodRiskEngine::ReferenceNumber.create }
    submitted_at { Time.current }

    after(:create) do |object|
      create(:exemption) if FloodRiskEngine::Exemption.count == 0

      exemption = FloodRiskEngine::Exemption.offset(rand(FloodRiskEngine::Exemption.count)).first

      object.enrollment_exemptions.create(
        exemption:,
        status: %w[pending being_processed].sample,
        valid_from: (Date.current - rand(7).days)
      )
    end

    trait :with_secondary_contact do
      association :secondary_contact, factory: :contact
    end
  end

  factory :confirmed, parent: :confirmed_random_pending, traits: %i[with_limited_company with_secondary_contact]

  factory :confirmed_no_secondary_contact, parent: :confirmed_random_pending, traits: [:with_limited_company]
end
