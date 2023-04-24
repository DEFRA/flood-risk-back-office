# frozen_string_literal: true

require "rails_helper"

RSpec.describe FloodRiskEngine::EnrollmentPolicy do
  subject(:enrollment_policy) { described_class.new(user, enrollment) }

  let(:enrollment) { create(:enrollment) }
  let(:enrollment_exemption) { enrollment.enrollment_exemptions.first }
  let(:user) { u = create(:user); u.add_role user_role; u }
    
  RSpec::Matchers.define :allow_user_to do |action|
    match { |policy| policy.send(action) }
  
    failure_message { "expected user to be able to #{action}, but it cannot" }  
    failure_message_when_negated { "expected the user not to be able to #{action}, but it can" }
  end

  RSpec.shared_examples "submitted / not submitted" do
    context "when the enrollment has not been submitted" do
      let!(:enrollment) { create(:enrollment, submitted_at: nil) }
  
      it { expect(enrollment_policy).not_to allow_user_to(:deregister?) }
      it { expect(enrollment_policy).not_to allow_user_to(:edit?) }
      it { expect(enrollment_policy).not_to allow_user_to(:update?) }
    end
  
    context "when the enrollment has been submitted" do
      let(:enrollment) { create(:enrollment, submitted_at: 1.hour.ago) }
  
      it { expect(enrollment_policy).to allow_user_to(:deregister?) }
      it { expect(enrollment_policy).to allow_user_to(:edit?) }
      it { expect(enrollment_policy).to allow_user_to(:update?) }
    end
  end

  context "with an admin_agent user" do
    let(:user) { u = create(:user); u.add_role :admin_agent; u }

    it { expect(enrollment_policy).to allow_user_to(:create?) }
    it { expect(enrollment_policy).to allow_user_to(:index?) }
    it { expect(enrollment_policy).to allow_user_to(:show?) }

    it { expect(enrollment_policy).not_to allow_user_to(:deregister?) }
    it { expect(enrollment_policy).not_to allow_user_to(:edit?) }
    it { expect(enrollment_policy).not_to allow_user_to(:update?) }
  end

  context "with a super_agent user" do
    let(:user) { u = create(:user); u.add_role :super_agent; u }

    it { expect(enrollment_policy).to allow_user_to(:index?) }
    it { expect(enrollment_policy).to allow_user_to(:show?) }
    it { expect(enrollment_policy).to allow_user_to(:create?) }

    it_behaves_like "submitted / not submitted"
  end

  context "with a system user" do
    let(:user) { u = create(:user); u.add_role :system; u }

    it { expect(enrollment_policy).to allow_user_to(:index?) }
    it { expect(enrollment_policy).to allow_user_to(:show?) }
    it { expect(enrollment_policy).to allow_user_to(:create?) }

    it_behaves_like "submitted / not submitted"
  end

  context "with a data_agent user" do
    let(:user) { u = create(:user); u.add_role :data_agent; u }

    it { expect(enrollment_policy).to allow_user_to(:index?) }
    it { expect(enrollment_policy).to allow_user_to(:show?) }

    it { expect(enrollment_policy).not_to allow_user_to(:create?) }
    it { expect(enrollment_policy).not_to allow_user_to(:deregister?) }
    it { expect(enrollment_policy).not_to allow_user_to(:edit?) }
    it { expect(enrollment_policy).not_to allow_user_to(:update?) }
  end

end
