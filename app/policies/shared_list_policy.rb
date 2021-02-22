class SharedListPolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  def add_contacts?
    record.user == user && record.initial?
  end

  def create_and_attach_folder?
    user.shared_lists.initial.blank?
  end

  def create_and_attach_document?
    user.shared_lists.initial.blank?
  end

  class Scope < Scope
    def resolve
      scope.where(user: user).initial
    end
  end
end
