require "rails_helper"

RSpec.describe Address do
  context "validations" do
    it { is_expected.to validate_presence_of(:premises) }
    it { is_expected.to validate_presence_of(:street_address) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:postcode) }
  end
end
