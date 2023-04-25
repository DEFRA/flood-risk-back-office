require "rails_helper"

RSpec.describe CorrespondenceContact do
  context "validations" do
    it { is_expected.to validate_presence_of(:full_name) }
    it { is_expected.to validate_presence_of(:telephone_number) }
    it { is_expected.to validate_presence_of(:email_address) }
  end
end
