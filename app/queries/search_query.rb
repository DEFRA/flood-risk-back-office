
class SearchQuery
  attr_reader :relation

  def self.call(search_form)
    new.call(search_form)
  end

  def initialize(_relation = FloodRiskEngine::EnrollmentExemption.all)
    @relation = FloodRiskEngine::EnrollmentExemption
                .joins(enrollment: [:organisation])
                .extending(Scopes)
  end
  # includes(enrollment: [
  #                 :organisation,
  #                 :site_address,
  #                 { correspondence_contact: :address }
  #               ])

  def call(search_form)
    relation
      .having_organisation_matching_query(search_form.q)
      .page(search_form.page)
      .per(search_form.per_page)
  end

  module Scopes
    def having_organisation_matching_query(q)
      q.blank? ? all : where("flood_risk_engine_organisations.name ilike ?", "%#{q}%")
    end

    def having_enrollment_matching_query(q)
      q.blank? ? all : where("flood_risk_engine_enrollments.blabl ilike ?", "%#{q}%")
    end
  end

  # rel = policy_scope(EnrollmentSearch).prefixed_any_search params[:q]

  # stage = params[:stage]

  # rel =
  #   if stage.blank? || stage == "submitted"
  #     rel.merge FloodRiskEngine::Enrollment.submitted
  #   elsif stage == "not_submitted"
  #     rel.merge FloodRiskEngine::Enrollment.not_submitted
  #   else
  #     # search for all stages of registration (not-submitted and submitted)
  #     rel
  #   end

  # rel = rel.
  #       joins(:enrollment).
  #       joins("LEFT OUTER JOIN dsc_organisations " \
  #             "ON dsc_organisations.id = dsc_enrollments.organisation_id").
  #       order("dsc_organisations.name").
  #       includes(enrollment: [
  #                 :organisation, :site_address,
  #                 { applicant_contact: :addresses },
  #                 { correspondence_contact: :addresses }
  #                ])

  # @enrollment_results    =  rel.page params[:page]
end
