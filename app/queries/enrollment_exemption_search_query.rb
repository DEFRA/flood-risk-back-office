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
    # Note the .joins help us build the search query, and the
    # .includes make sure we don't have any N+1 queries
    @relation = FloodRiskEngine::EnrollmentExemption
                .joins { enrollment.organisation.outer.primary_address.outer }
                .joins { enrollment.correspondence_contact.outer }
                .joins { exemption }
                .includes { exemption }
                .includes { enrollment.organisation }
                .extending(Scopes)
  end

  # Note .page and .per_page are kaminari methods
  def call(search_form)
    relation
      .having_status(search_form.status)
      .matching_query(search_form.q)
      .sort_depending_on_status(search_form.status)
      .page(search_form.page)
      .per(search_form.per_page)
  end

  module Scopes
    # rubocop:disable Metrics/AbcSize
    def matching_query(q)
      return all if q.blank?
      fuzzy_q = "%#{q}%"
      where do
        (exemption.code =~ q) |
          (enrollment.organisation.name =~ fuzzy_q) |
          (enrollment.reference_number =~ fuzzy_q) |
          (enrollment.correspondence_contact.full_name =~ fuzzy_q) |
          (enrollment.organisation.primary_address.postcode =~ fuzzy_q)
      end
    end

    def having_status(target_status)
      return all if target_status.blank?
      where { status == FloodRiskEngine::EnrollmentExemption.statuses[target_status] }
    end

    def sort_depending_on_status(status)
      direction = (status.to_sym == :pending) ? :asc : :desc
      order { enrollment.submitted_at.send(direction) }
    end
  end
end
