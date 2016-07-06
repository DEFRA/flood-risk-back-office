require "rails_helper"

RSpec.describe EnrollmentExport do
  it { is_expected.to respond_to :populate_file_name }

  describe "populate_file_name" do
    it "should increment populate_file_name for same dates" do
      ee_existing = create(:enrollment_export, :completed)

      ee = build(:enrollment_export, :with_dates)

      expect { ee.populate_file_name }.to change { ee.file_name }.from(nil)

      date_as_string = ee_existing.date_for_filename(ee_existing.from_date)

      expect(ee.file_name).to include(date_as_string)
      expect(ee_existing.file_name).to include(date_as_string)

      expect(ee_existing.file_name).to_not eq(ee.populate_file_name)
    end
  end

  describe "scopes" do
    let(:export) { create(:enrollment_export, :with_dates, :with_file_name) }

    before(:each) do
      FactoryGirl.create_list(:page_declaration, 5) # not submitted - should never appear

      FactoryGirl.create_list(:submitted_individual, 3)
      FactoryGirl.create_list(:submitted_partnership, 3)

      FactoryGirl.create_list(:approved_individual, 4)
      FactoryGirl.create_list(:rejected_limited_company, 2)
    end

    it "should select all submitted records" do
      export.date_field_scope = "submitted_at"
      expect(export.reportable_records.count).to eq 12
    end

    it "should select only approved/rejected" do
      export.date_field_scope = "decision_at"
      expect(export.reportable_records.count).to eq 6
    end
  end
end
