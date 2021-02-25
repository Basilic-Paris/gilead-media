class Admin::FolderPolicy < ApplicationPolicy
  def destroy?
    user.admin?
  end
end
