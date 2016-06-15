class EnrollmentExportPolicy < ApplicationPolicy
  def index?
    user.present? && user.has_any_role?
  end

  def create?
    user.present? && user.has_any_role?
  end

  def show?
    user.present? && user.has_any_role? && record.completed?
  end

  class Scope < Scope
    def resolve
      if user.try! :has_any_role?
        scope.all
      else
        scope.none
      end
    end
  end
end
