require "rails_helper"

RSpec.describe Address do
  context "validations" do
    it { should validate_presence_of(:premises) }
    it { should validate_presence_of(:street_address) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:postcode) }
  end
end
