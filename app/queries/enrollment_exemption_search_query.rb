# frozen_string_literal: true

class EnrollmentExemptionSearchQuery
  attr_reader :relation

  def self.call(search_form)
    new.call(search_form)
  end

  def initialize
    @relation =
      FloodRiskEngine::EnrollmentExemption
      .joins(
        :exemption,
        enrollment:
          [
            :reference_number,
            :correspondence_contact,
            :exemption_location,
            { organisation: :primary_address }
          ]
      )
      .extending(Scopes)
  end

  def call(search_form)
    relation
      .having_status(search_form.status)
      .matching_query(search_form.q)
      .sort
      .page(search_form.page)
      .per(search_form.per_page)
  end

  module Scopes

    def matching_query(query_to_match)
      return all if query_to_match.blank?

      query = SearchTerm.new(query_to_match)

      where(flood_risk_engine_reference_numbers: { number: query.q })
        .or(where("flood_risk_engine_exemptions.code LIKE ?", query.fuzzy))
        .or(where("UPPER(flood_risk_engine_organisations.name) LIKE ?", query.fuzzy))
        .or(where("UPPER(flood_risk_engine_contacts.full_name) LIKE ?", query.fuzzy))
        .or(
          where("UPPER(REPLACE(flood_risk_engine_addresses.postcode, ' ','')) LIKE ?",
                query.fuzzy_without_whitespace)
        )
        .or(
          where("UPPER(REPLACE(flood_risk_engine_locations.grid_reference, ' ','')) LIKE ?",
                query.fuzzy_without_whitespace)
        )
    end

    def having_status(target_status)
      return all if target_status.blank?

      where(status: FloodRiskEngine::EnrollmentExemption.statuses[target_status])
    end

    def sort
      order(
        [
          "flood_risk_engine_enrollments.submitted_at ASC",
          "flood_risk_engine_enrollments.created_at ASC"
        ]
      )
    end

    class SearchTerm
      attr_reader :q

      def initialize(query_to_search = "")
        @q = query_to_search.strip.upcase
      end

      def without_whitespace
        @without_whitespace ||= @q.delete(" ")
      end

      def fuzzy
        @fuzzy ||= "%#{@q}%"
      end

      def fuzzy_without_whitespace
        @fuzzy_without_whitespace ||= "%#{without_whitespace}%"
      end
    end
  end
end
