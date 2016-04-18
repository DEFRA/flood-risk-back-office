class EnrollmentSearchPolicy < ApplicationPolicy
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
