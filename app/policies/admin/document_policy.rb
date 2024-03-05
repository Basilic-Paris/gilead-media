class Admin::DocumentPolicy < ApplicationPolicy
  def unactive?
    user.admin? && record.active?
  end

  def active?
    user.admin? && record.inactive?
  end

  def archive?
    user.admin? && record.active?
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
