class Admin::DocumentPolicy < ApplicationPolicy
  def validate?
    user.admin? && record.valid? && !record.validated?
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

  def attach_to_folder?
    user.admin?
  end

  # class Scope < Scope
  #   def resolve
  #     scope.all
  #   end
  # end
end
