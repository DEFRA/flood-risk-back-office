require "rails_helper"

RSpec.describe Organisation do
  context "validations" do
    it { should validate_presence_of(:name) }
  end
end
