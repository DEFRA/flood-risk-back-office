# frozen_string_literal: true

require "rails_helper"

RSpec.describe EnrollmentExemptionSearchQuery, type: :query do
  subject { described_class.call(search_form).all.map(&:enrollment) }

  let!(:approved_individual) { create(:approved_individual) }
  let!(:rejected_individual) { create(:rejected_individual) }

  let(:search_term) { "" }
  let(:status) { nil }

  let(:search_form) do
    SearchForm.new(
      {
        search: {
          q: search_term,
          status:
        }
      }
    )
  end

  describe "filter by status" do
    it "finds all the enrollments" do
      expect(subject).to eq([approved_individual, rejected_individual])
    end

    context "status = approved" do
      let(:status) { :approved }

      it "finds the approved enrollment" do
        expect(subject).to eq([approved_individual])
      end
    end
  end

  describe "by something that doesn't exist" do
    let(:search_term) { "foo_bar_xyz" }

    it "finds nothing" do
      expect(subject).to be_empty
    end
  end

  describe "by reference_number" do
    let(:search_term) { approved_individual.ref_number.downcase }

    it "finds the approved enrollment" do
      expect(subject).to eq([approved_individual])
    end
  end

  describe "by organisation name" do
    let(:search_term) { approved_individual.organisation.name }

    it "finds the approved enrollment" do
      expect(subject).to eq([approved_individual])
    end
  end

  describe "by contact name" do
    let(:search_term) { approved_individual.correspondence_contact.full_name }

    it "finds the approved enrollment" do
      expect(subject).to eq([approved_individual])
    end
  end

  describe "by postcode" do
    let(:search_term) { "Bs15Ah" }

    it "finds all the enrollments" do
      expect(subject).to eq([approved_individual, rejected_individual])
    end
  end
end
