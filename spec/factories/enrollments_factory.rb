FactoryGirl.define do
  # Base class for BO Enrollments - Start in PEDNING

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

    status "pending"
  end

  # Base class for BO Enrollment with a random exemption, status, and valid_from selected for EnrollmentExemption

  factory :confirmed_random_status, parent: :base_back_office_enrollment do
    after(:create) do |object|
      exemption = FloodRiskEngine::Exemption.offset(rand(FloodRiskEngine::Exemption.count)).first || create(:exemption)

      object.enrollment_exemptions.build(
        exemption: exemption,
        status: FloodRiskEngine::EnrollmentExemption.statuses.keys.sample,
        valid_from: (Date.current - rand(7).days)
      )

      object.submit
    end

    trait :with_secondary_contact do
      association :secondary_contact, factory: :contact
    end

    step :confirmation
  end

  factory :confirmed, parent: :confirmed_random_status, traits: [:with_limited_company, :with_secondary_contact]

  factory :confirmed_no_secondary_contact, parent: :confirmed_random_status, traits: [:with_limited_company]

  # A suite of Enrollments that enable you to test exports and back office functions against Confirmed enrollments
  #
  # Named :   confirmed_#{org_type}
  #
  FloodRiskEngine::Organisation.org_types.keys.each do |ot|
    next if ot.to_sym == :unknown

    factory :"confirmed_#{ot}", parent: :confirmed_random_status do
      after(:create) do |object|
        if ot.to_sym == :partnership
          object.organisation = create(:organisation, :"as_#{ot}", :with_partners, name: Faker::Company.name)
        else
          object.organisation = create(:organisation, :"as_#{ot}", name: Faker::Company.name)
        end

        # this is an optional page in FO so create randomly
        object.secondary_contact = build :contact #if [true, false].sample

        object.save!
      end
    end
  end
end
