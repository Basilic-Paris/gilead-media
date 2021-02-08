class SharedFolderPolicy < ApplicationPolicy
  def create?
    user.shared_lists.initial.present?
  end
end
