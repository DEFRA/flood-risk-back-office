# frozen_string_literal: true

require "csv"

module Reports
  class EprSerializer
    ATTRIBUTES = {
      accept_reject_decision_at: "Decision date",
      ref_number: "Exemption reference number",
      grid_reference: "NGR",
      water_management_area_long_name: "Water management area",
      code: "Exemption code and description",
      organisation_details: "Operator name"
    }.freeze

    def to_csv(file_path)
      CSV.open(file_path, "wb", force_quotes: true) do |csv|
        csv << ATTRIBUTES.values

        FloodRiskEngine::EnrollmentExemption.includes(:enrollment, :exemption)
                                            .approved
                                            .each do |enrollment_exemption|
          csv << parse_enrollment_exemption(enrollment_exemption)
        end
      end
    end

    private

    def parse_enrollment_exemption(enrollment_exemption)
      presenter = EprPresenter.new(enrollment_exemption)

      ATTRIBUTES.keys.map do |key|
        presenter.public_send(key)
      end
    end
  end
end
