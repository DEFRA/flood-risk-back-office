require "rails_helper"

RSpec.describe CorrespondenceContact do
  context "validations" do
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:telephone_number) }
    it { should validate_presence_of(:email_address) }
  end
end
