FactoryBot.define do
  # A suite of Enrollments that enable you to test exports and back office functions against Rejected enrollments
  #
  # Named :rejected_#{org_type}
  #
  FloodRiskEngine::Organisation.org_types.keys.each do |ot|
    next if ot.to_sym == :unknown

    factory :"rejected_#{ot}", parent: :"submitted_#{ot}", traits: [:accept_reject_common] do
      after(:create) do |object|
        ee = object.enrollment_exemptions.first

        ee.comments << build_list(:comment, rand(5), :with_user_id, event: "Rejected exemption")
        ee.rejected!

        object.update secondary_contact: create(:contact)
      end
    end
  end
end
