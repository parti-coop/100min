class SuggestionPolicy < ApplicationPolicy
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
    user.present? and user != record.user
  end
end
