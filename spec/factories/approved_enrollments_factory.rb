FactoryGirl.define do
  # A suite of Enrollments that enable you to test exports and back office functions against Approved enrollments
  #
  # Named :approved_#{org_type}
  #
  # The submitted_at date will be 6 months ago
  # The approval date will be a random date between the submitted_at date and NOW
  #
  FloodRiskEngine::Organisation.org_types.keys.each do |ot|
    next if ot.to_sym == :unknown

    factory :"approved_#{ot}", parent: :"submitted_#{ot}", traits: [:accept_reject_common] do
      after(:create) do |object|
        ee = object.enrollment_exemptions.first
        ee.comments << build_list(:comment, rand(5), :with_user_id, event: "Approved exemption")
        ee.approved!
        object.update secondary_contact: create(:contact)
      end
    end
  end
end
