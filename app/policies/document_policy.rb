class DocumentPolicy < ApplicationPolicy
  def show?
    true
  end

  # TO KEEP: initial version to add folders or documents to shared list directly
  # def add_to_shared_list?
  #   true
  # end

  def add_to_shared_list_or_folder?
    true
  end

  def attach_to_new_shared_list?
    user.shared_lists.initial.blank?
  end

  def attach_to_existing_shared_list?
    !attach_to_new_shared_list?
  end

  def download?
    true
  end

  class Scope < Scope
    def resolve
      user.admin? ? scope.all : scope.active
    end
  end
end
