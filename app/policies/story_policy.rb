class StoryPolicy < ApplicationPolicy
  def new?
    admin_only
  end

  def create?
    admin_only
  end

  def update?
    admin_only
  end

  def destroy?
    admin_only
  end
end
