FactoryGirl.define do
  # A suite of Enrollments that enable you to test exports and back office functions against Approved enrollments
  #
  # Named :approved_#{org_type}
  #
  FloodRiskEngine::Organisation.org_types.keys.each do |ot|
    next if ot.to_sym == :unknown

    factory :"approved_#{ot}", parent: :"confirmed_#{ot}" do
      step :confirmation

      after(:create) do |object|
        object.enrollment_exemptions.first.approved!
        object.update secondary_contact: create(:contact)
      end
    end
  end
end
