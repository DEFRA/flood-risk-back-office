require "rails_helper"

RSpec.describe EnrollmentExport do
  describe "#populate_file_name" do
    it "increments populate_file_name for same dates" do
      ee_existing = create(:enrollment_export, :completed)

      ee = build(:enrollment_export, :with_dates)

      expect { ee.populate_file_name }.to change { ee.file_name }.from(nil)

      date_as_string = ee_existing.date_for_filename(ee_existing.from_date)

      expect(ee.file_name).to include(date_as_string)
      expect(ee_existing.file_name).to include(date_as_string)

      expect(ee_existing.file_name).not_to eq(ee.populate_file_name)
    end
  end

  context "scopes" do
    let(:export) { create(:enrollment_export, :with_dates, :with_file_name) }

    before do
      FactoryBot.create_list(:submitted_individual, 3)
      FactoryBot.create_list(:submitted_partnership, 3)

      FactoryBot.create_list(:approved_individual, 4)
      FactoryBot.create_list(:rejected_limited_company, 2)
    end

    it "selects all submitted records" do
      export.date_field_scope = "submitted_at"
      expect(export.reportable_records.count).to eq 12
    end

    it "selects only approved/rejected" do
      export.date_field_scope = "decision_at"
      expect(export.reportable_records.count).to eq 6
    end
  end

  context "validations" do
    it { is_expected.to validate_presence_of :from_date }
    it { is_expected.to validate_presence_of :to_date }
    it { is_expected.to validate_presence_of :created_by }
    it { is_expected.to validate_presence_of :date_field_scope }

    context "on_or_before" do
      let(:enrollment_export) { build(:enrollment_export) }
      let(:errors) do
        enrollment_export.validate
        enrollment_export.errors
      end

      it "validates the from_date" do
        enrollment_export.from_date = 1.day.from_now

        expect(errors[:from_date]).to include("From date cannot be in the future")
      end

      it "validates the to_date" do
        enrollment_export.to_date = 1.day.from_now

        expect(errors[:to_date]).to include("To date cannot be in the future")
      end

      it "validates the to_date is not before the from_date" do
        enrollment_export.to_date = 2.days.ago
        enrollment_export.from_date = 1.day.ago

        expect(errors[:to_date]).to include("To date must be on or after the from date")
      end
    end
  end
end
