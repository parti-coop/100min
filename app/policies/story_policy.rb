class StoryPolicy < ApplicationPolicy
  def new?
    user.admin? or true
  end

  def create?
    user.admin? or true
  end

  def update?
    user.admin? or true
  end

  def destroy?
    user.admin? or true
  end
end
