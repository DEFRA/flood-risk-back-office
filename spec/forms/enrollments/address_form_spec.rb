require "rails_helper"
require "shoulda/matchers"
module Enrollments
  RSpec.describe AddressForm, type: :form do
    let(:enrollment) { FactoryBot.create(:enrollment) }
    let(:address) { FactoryBot.create(:simple_address) }

    let(:form) { described_class.new(enrollment, address) }

    it "should validate organisation_name presence" do
      expect(form).to validate_presence_of(:postcode)
        .with_message(
          I18n.t("flood_risk_engine.validation_errors.postcode.blank")
        )
    end
  end
end
