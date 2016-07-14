RSpec.feature "Change enrollment's assistance mode" do
  let(:user) { create(:user).tap { |u| u.add_role :system } }

  let(:enrollment) { create :confirmed }
  let(:enrollment_exemption) { enrollment.enrollment_exemptions.first }

  before(:each) do
    login_as user

    visit admin_enrollment_exemption_path(enrollment_exemption)
  end

  scenario "The user should be set on a new enrollment" do
    visit new_admin_enrollment_path

    expect(FloodRiskEngine::Enrollment.last.updated_by_user_id).to eq(user.id)
  end
end
