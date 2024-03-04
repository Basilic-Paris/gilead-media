class Admin::AttachmentPolicy < ApplicationPolicy
  def destroy?
    user.admin?
  end
end
