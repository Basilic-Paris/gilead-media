class SharedFolderPolicy < ApplicationPolicy
  def new?
    create?
  end

  def create?
    true
  end
end
