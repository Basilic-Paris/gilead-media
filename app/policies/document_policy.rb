class DocumentPolicy < ApplicationPolicy
  def show?
    true
  end

  # TO KEEP: initial version to add folders or documents to shared list directly
  # def add_to_shared_list?
  #   true
  # end

  class Scope < Scope
    def resolve
      user.admin? == true ? scope.all : scope.all.validated
    end
  end
end
