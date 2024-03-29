FactoryBot.define do
  ## SUBMITTED

  # A suite of Enrollments that enable you to test exports and back office functions against Submitted enrollments
  #
  # Named :   submitted_#{org_type}
  #
  FloodRiskEngine::Organisation.org_types.each_key do |ot|
    next if ot.to_sym == :unknown

    factory :"submitted_#{ot}", parent: :confirmed_random_pending do
      reference_number { FloodRiskEngine::ReferenceNumber.create }
      submitted_at { Time.current }

      after(:create) do |object|
        object.organisation = if ot.to_sym == :partnership
                                create(:organisation, :"as_#{ot}", :with_partners, name: Faker::Company.name)
                              else
                                create(:organisation, :"as_#{ot}", name: Faker::Company.name)
                              end

        object.organisation.primary_address = build :simple_address

        object.secondary_contact = build :contact

        object.save!
      end

      trait :accept_reject_common do
        after(:create) do |object|
          ee = object.enrollment_exemptions.first

          from = 6.months.ago

          object.submitted_at = from
          ee.valid_from = from

          to = DateTime.current.to_f
          ee.accept_reject_decision_at = Time.zone.at(from.to_f + (rand * (to - from.to_f)))

          user = User.limit(1).order("RANDOM()").pluck(:id).first || create(:user).id
          ee.accept_reject_decision_user_id = user

          ee.save!
        end
      end
    end
  end
end
