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
    user.can_sell?
  end

  def build?
    user.can_build?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
