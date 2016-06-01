module FloodRiskEngine
  class EnrollmentPolicy < ApplicationPolicy
    def index?
      user.present? && user.has_any_role?
    end

    def create?
      system_user? || super_agent_user? || admin_agent_user?
    end

    def show_continue_button?
      create? && record.present? && !record.complete?
    end

    # Determines visibility of for instance the Resume button on the enrollment's page
    # in the back office. It is only possible to resume an enrollment if it is not
    # complete - otherwise the Edit button applies i.e. Resume is hidden and Edit is visible,
    def resume?
      create? && record.present? # TODO: && !record.submitted?
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
      deregister?
    end

    # Whether we can edit an erollment's exemptions.
    # This needs to live here rather than in the enrollment_exemptions policy
    # as here we have an enrollment, but there we would have neither an instantiated
    # enrollment_exemptions or enrollment.
    def edit_exemptions?
      !record.submitted?
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

    private

    def enrollment_submitted?
      # TODO
      record.present? # &&
      # record.status_active? &&
      # record.submitted_at?
    end
  end
end
