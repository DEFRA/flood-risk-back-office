# frozen_string_literal: true

# A query object to rapw up the nasty gubbins behind pseudo full-text searching
# for enrollment exemptions. In an ideal world you might do this using elastic search.
# Here we use squeel to make to querying less painful, and the pattern of mixing
# custom scope into the relation to make the code easy(er) to read.
class EnrollmentExemptionSearchQuery
  attr_reader :relation

  def self.call(search_form)
    new.call(search_form)
  end

  def initialize
    # Note the .joins (using squeel for brevity) help us build the search query, and the
    # .includes make sure we don't have any N+1 queries
    @relation = FloodRiskEngine::EnrollmentExemption
                .joins { enrollment.organisation.outer.primary_address.outer }
                .joins { enrollment.correspondence_contact.outer }
                .joins { enrollment.exemption_location.outer }
                .joins { enrollment.reference_number.outer }
                .joins { exemption }
                .includes(:exemption,
                          enrollment: [
                            :reference_number,
                            {
                              organisation: [:primary_address]
                            }
                          ])
                .extending(Scopes)
  end

  # Note .page and .per_page are kaminari methods
  def call(search_form)
    relation
      .having_status(search_form.status)
      .matching_query(search_form.q)
      .sort
      .page(search_form.page)
      .per(search_form.per_page)
  end

  module Scopes

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Naming/MethodParameterName
    def matching_query(q)
      return all if q.blank?

      query = SearchTerm.new(q)
      where do
        (exemption.code =~ query.q) |
          (replace(enrollment.organisation.primary_address.postcode, " ", "") =~ query.fuzzy_without_whitespace) |
          (replace(enrollment.exemption_location.grid_reference, " ", "") =~ query.without_whitespace) |
          (enrollment.organisation.name =~ query.fuzzy) |
          (enrollment.organisation.searchable_content =~ query.fuzzy) |
          (enrollment.reference_number.number =~ query.fuzzy) |
          (enrollment.correspondence_contact.full_name =~ query.fuzzy)
      end
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Naming/MethodParameterName

    def having_status(target_status)
      return all if target_status.blank?

      where { status == FloodRiskEngine::EnrollmentExemption.statuses[target_status] }
    end

    def sort
      order { [enrollment.submitted_at.asc, enrollment.created_at.asc] }
    end

    class SearchTerm
      attr_reader :q

      # rubocop:disable Naming/MethodParameterName
      def initialize(q = "")
        @q = q.strip
      end
      # rubocop:enable Naming/MethodParameterName

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
