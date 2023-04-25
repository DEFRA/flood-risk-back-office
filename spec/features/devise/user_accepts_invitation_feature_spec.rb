#  As an NCCC System user, I want to be able to invite users
RSpec.describe "User accepts invitation" do
  let(:email_addr) { Faker::Internet.email }

  context "user views the accept invitation page" do
    let(:user) { User.new(email: email_addr) }

    before do
      user.invite!
    end

    it "the form and both password fields have 'autocomplete' disabled" do
      invite_path = accept_user_invitation_path(invitation_token: user.raw_invitation_token)
      visit invite_path

      the_form = page.find("form")
      expect(the_form[:autocomplete]).to eq "off"

      the_two_password_fields = page.all("input[type='password']")
      expect(the_two_password_fields.count).to eq(2)
      expect(the_two_password_fields.pluck(:autocomplete).uniq).to eq ["off"]
    end
  end
end
