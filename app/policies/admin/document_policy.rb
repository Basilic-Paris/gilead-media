class Admin::DocumentPolicy < ApplicationPolicy
  def show?
    user.admin?
  end

  def validate?
    user.admin? && !record.validated?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin?
  end

  # class Scope < Scope
  #   def resolve
  #     scope.all
  #   end
  # end
end
