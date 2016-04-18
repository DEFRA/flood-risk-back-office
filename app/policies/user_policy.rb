class UserPolicy < ApplicationPolicy
  def index?
    system_user?
  end

  def update?
    system_user?
  end

  def show?
    super && update?
  end

  def invite?
    system_user?
  end

  def enable?
    system_user? && record.id && user.id != record.id
  end

  def disable?
    system_user? && record.id && user.id != record.id
  end

  class Scope < Scope
    def resolve
      if user && (user.has_cached_role?(:system) || user.has_role?(:system))
        scope.unscoped.includes(:roles)
      else
        scope.none
      end
    end
  end
end
