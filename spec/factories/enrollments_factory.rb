FactoryGirl.define do
  # Base class for each approved OrgType
  factory :confirmed_approved_base, class: FloodRiskEngine::Enrollment do
    after(:create) do |object|
      object.exemption_location = build(:location, description: "#{FFaker::Address.neighborhood}, near river.")

      object.organisation.primary_address = build(:simple_address)
      object.correspondence_contact = build(:flood_risk_engine_contact, email_address: Faker::Internet.email)

      exemption = FloodRiskEngine::Exemption.offset(rand(FloodRiskEngine::Exemption.count)).first || create(:exemption)

      object.enrollment_exemptions.build(
        exemption: exemption,
        status: :approved,
        valid_from: (Date.current - rand(7).days)
      )

      object.secondary_contact = build :contact

      object.save
    end

    step :confirmation
    status :approved
  end

  # A suite of Enrollments that enable you to test exports and back office funcitons against Confirmed enrollments

  FloodRiskEngine::Organisation.org_types.keys.each do |ot|
    next if ot.to_sym == :unknown
    factory :"approved_#{ot}", parent: :confirmed_approved_base do
      after(:build) do |object|
        object.organisation = create(:organisation, :"as_#{ot}", name: Faker::Company.name)
      end
    end
  end
end
