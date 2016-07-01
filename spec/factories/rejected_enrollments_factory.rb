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
        ee = object.enrollment_exemptions.first

        from = object.created_at.to_f
        to = 1.year.from_now.to_f

        ee.accept_reject_decision_at = Time.zone.at(from + rand * (to - from))

        user = User.limit(1).order("RANDOM()").pluck(:id).first || create(:user).id

        ee.accept_reject_decision_user_id = user
        ee.comments << build_list(:comment, rand(5), :with_user_id, event: "Rejected exemption")
        ee.rejected!

        object.update secondary_contact: create(:contact)
      end
    end
  end
end
