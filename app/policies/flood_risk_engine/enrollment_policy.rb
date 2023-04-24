module FloodRiskEngine
  class EnrollmentPolicy < ApplicationPolicy
    alias enrollment record

    def index?
      user.present? && user.has_any_role?
    end

    def create?
      system_user? || super_agent_user? || admin_agent_user?
    end

    def show?
      super && user.present? && user.has_any_role?
    end

    def deregister?
      (system_user? || super_agent_user?) && enrollment_submitted?
    end

    def edit?
      (system_user? || super_agent_user? || admin_agent_user?) && enrollment_submitted?
    end

    def update?
      edit?
    end

    class Scope < Scope
      def resolve
        if user&.has_any_role?
          scope.all
        else
          scope.none
        end
      end
    end

    private

    def enrollment_submitted?
      enrollment.present? && enrollment.submitted?
    end
  end
end
