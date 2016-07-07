require "rails_helper"
require "shoulda/matchers"

module Admin

  module Enrollment
    RSpec.describe ExportForm, type: :form do
      let(:enrollment) { build(:enrollment_export) }

      let(:form) { Admin::Enrollment::ExportForm.new(enrollment) }

      subject { form }

      it { is_expected.to be_a(ExportForm) }

      describe "#model" do
        it "is the correct type" do
          expect(subject.model).to be_a(EnrollmentExport)
        end
      end

      context "validate presence_of" do
        it { is_expected.to validate_presence_of :from_date }
        it { is_expected.to validate_presence_of :to_date }

        it do
          is_expected.to validate_presence_of(:created_by).strict.with_message("Created by can't be blank")
        end

        it do
          is_expected.to validate_presence_of(:state).strict.with_message("State can't be blank")
        end

        it do
          is_expected.to validate_presence_of(:date_field_scope).strict.with_message("Date field scope can't be blank")
        end
      end

      context "form validation" do
        it "is valid if :state included in allowed states" do
          is_expected.to validate_inclusion_of(:state).in_array(%w(queued started completed failed))
        end

        it "is valid if :date_field_scope included in allowed date scopes" do
          is_expected.to validate_inclusion_of(:date_field_scope).in_array(%w(submitted_at decision_at))
        end

        describe "To Date" do
          context("valid") do
            # bit clunky but can't use a let here
            from_date = Date.current - 20.days

            [from_date, Date.current, from_date + 1.day, from_date + rand(2..19).days].each do |d|
              it "when TO date [#{d}] is on or AFTER FROM date ]#{from_date}]", duff: true do
                params = { "#{form.params_key}": { from_date: from_date, to_date: d } }
                expect(form.validate(params)).to eq true
              end
            end
          end

          context("invalid") do
            # bit clunky but can't use a let here
            from_date = Date.current - 10.days

            [from_date - 1.day, from_date - rand(1..30).weeks].each do |d|
              it "when TO date [#{d}] is BEFORE than FROM date [#{from_date}]" do
                msg = "To date must be on or after the from date"

                params = { "#{form.params_key}": { from_date: from_date, to_date: d } }

                expect(form.validate(params)).to eq false
                expect(form.errors.messages[:to_date]).to eq([msg])
              end
            end

            it "when :state not in allowed states" do
              params = { "#{form.params_key}": { state: :blah } }
              expect(form.validate(params)).to eq false
              expect(
                form.errors.messages[:state]
              ).to eq [I18n.t("activemodel.errors.models.admin/enrollment/export.attributes.state.inclusion")]
            end

            it "and raises strict error when created_by not present" do
              params = { "#{form.params_key}": { created_by: nil } }
              expect { form.validate(params) }.to raise_error ActiveModel::StrictValidationFailed
            end
          end
        end

        describe "#save" do
          it "saves the report dates when supplied" do
            params = { "#{form.params_key}": {
              date_field_scope: "decision_at",
              from_date: Date.current - 2.days,
              to_date:  Date.current
            } }

            expect(form.validate(params)).to eq true
            expect(form.save).to eq true

            expected = EnrollmentExport.last
            expect(expected.from_date).to eq(Date.current - 2.days)
            expect(expected.to_date).to eq Date.current

            expect(expected.state).to_not be_empty
            expect(expected.created_by).to_not be_empty

            expect(expected.date_field_scope).to eq "decision_at"
          end
        end
      end
    end
  end
end
