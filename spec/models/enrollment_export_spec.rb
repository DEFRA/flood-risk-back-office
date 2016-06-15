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
end
