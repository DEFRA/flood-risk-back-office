# frozen_string_literal: true

class TransientRegistrationCleanupService < FloodRiskEngine::BaseService
  def run
    transient_registrations_to_remove.destroy_all
  end

  private

  def transient_registrations_to_remove
    FloodRiskEngine::TransientRegistration.where("created_at < ?", oldest_possible_date)
  end

  def oldest_possible_date
    max = Rails.configuration.max_transient_registration_age_days.to_i
    max.days.ago.beginning_of_day
  end
end
