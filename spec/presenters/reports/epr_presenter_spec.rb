# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe EprPresenter do
    let(:object) { double(:object) }

    subject { described_class.new(object) }

    describe "#accept_reject_decision_at" do
      it "returns a formatted date" do
        date = Date.new 2018, 1, 1

        allow(object).to receive(:accept_reject_decision_at).and_return(date)

        expect(subject.accept_reject_decision_at).to eq("2018-01-01")
      end
    end

    describe "#organisation_details" do
      let(:organisation) { double(:organisation, partnership?: false, name: "organisation name") }

      before do
        allow(object).to receive(:enrollment).and_return(double(:enrollment, organisation:))
      end

      it "returns the organisation's name" do
        expect(subject.organisation_details).to eq("organisation name")
      end

      context "when there is no organisation" do
        let(:organisation) { nil }

        it "returns a blank value" do
          expect(subject.organisation_details).to eq("Not specified")
        end
      end

      context "when the organisation is a partnership" do
        let(:organisation) { double(:organisation, partnership?: true) }

        before do
          partners = [
            double(:partner1, contact: double(:contact, full_name: "Enzo DeRegister")),
            double(:partner2, contact: double(:contact, full_name: "Fenzo Register"))
          ]
          allow(organisation).to receive(:partners).and_return(partners)
        end

        it "returns a string with all partners names" do
          expect(subject.organisation_details).to eq("Enzo DeRegister, Fenzo Register")
        end
      end
    end

    describe "#water_management_area_long_name" do
      let(:long_name) { Faker::Lorem.sentence }
      let(:area) { create(:water_management_area, long_name:) }
      let(:location) { build(:location, water_management_area: area) }
      let(:enrollment) { build(:enrollment, exemption_location: location) }

      before { allow(object).to receive(:enrollment).and_return(enrollment) }

      it "returns the expected name" do
        expect(subject.water_management_area_long_name).to eq long_name
      end
    end
  end
end
