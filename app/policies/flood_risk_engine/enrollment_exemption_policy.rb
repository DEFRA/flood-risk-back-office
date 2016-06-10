module FloodRiskEngine
  class EnrollmentExemptionPolicy < ApplicationPolicy
    def show?
      user.present? && user.has_any_role?
    end
  end
end
