class OrganisationPolicy < ApplicationPolicy
  def edit?
    system_user? || super_agent_user? || admin_agent_user?
  end
  alias update? edit?
end
