class FolderPolicy < ApplicationPolicy
  def show?
    true
  end

  def download?
    true
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
