require "rails_helper"

RSpec.describe SearchForm, type: :form do
  subject { described_class.new({}) }
  it { is_expected.to respond_to :status_filter_options }
  it { is_expected.to respond_to :q }
  it { is_expected.to respond_to :page }
  it { is_expected.to respond_to :per_page }

  describe "#status_filter_options" do
    it "returns the correct statuses" do
      expected_options = FloodRiskEngine::EnrollmentExemption.statuses.keys
      expect(subject.status_filter_options).to eq(expected_options)
    end
  end

  describe "#page" do
    it "defaults to 1" do
      expect(subject.page).to eq(1)
    end
  end

  describe "#per_page" do
    it "defaults to 20" do
      expect(subject.per_page).to eq(20)
    end
  end

  describe "#new" do
    it "can be initialized with some params" do
      params = {
        page: 23,
        per_page: 4,
        search: {
          q: "a query",
          status: "pending"
        }
      }
      form = described_class.new(params)
      expect(form.q).to eq("a query")
      expect(form.page).to eq(23)
      expect(form.per_page).to eq(4)
      expect(form.status).to eq("pending")
    end
  end
end
