class CommentPolicy < ApplicationPolicy
  def new?
    user.present?
  end

  def create?
    user.present?
  end

  def edit?
    user == record.user
  end

  def update?
    user == record.user
  end

  def destroy?
    user.try(:admin?) or user == record.user
  end

  def like?
    user.present?
  end
end
