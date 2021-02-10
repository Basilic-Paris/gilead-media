class FolderSharedListPolicy < ApplicationPolicy
  def create?
    user.shared_lists.initial.present?
  end
end
