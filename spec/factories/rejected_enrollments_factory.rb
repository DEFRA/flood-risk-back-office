FactoryGirl.define do
  # A suite of Enrollments that enable you to test exports and back office functions against Rejected enrollments
  #
  # Named :rejected_#{org_type}
  #
  FloodRiskEngine::Organisation.org_types.keys.each do |ot|
    next if ot.to_sym == :unknown

    factory :"rejected_#{ot}", parent: :"confirmed_#{ot}" do
      step :confirmation

      after(:create) do |object|
        object.secondary_contact = build :contact
        object.enrollment_exemptions.first.rejected! # this required .. this don't work : status :rejected
      end
    end
  end
end
