class FolderPolicy < ApplicationPolicy
  def show?
    true
  end

  def download?
    true
  end

  def add_to_shared_list?
    true
  end

  def attach_to_new_shared_list?
    user.shared_lists.initial.blank?
  end

  def attach_to_existing_shared_list?
    !attach_to_new_shared_list?
  end

  # TO KEEP: initial version to add folders or documents to shared list directly
  # def add_to_shared_list?
  #   true
  # end

  class Scope < Scope
    def resolve
      user.admin? == true ? scope.all.with_documents : scope.all.with_validated_documents
    end
  end
end
