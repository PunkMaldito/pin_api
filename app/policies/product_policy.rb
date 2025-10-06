class ProductPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    user.present?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def sell?
    user.seller? || user.admin?
  end

  def build?
    user.builder? || user.admin?
  end
end
