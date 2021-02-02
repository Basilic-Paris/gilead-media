class DocumentPolicy < ApplicationPolicy
  def show?
    true
  end

  def add_to_shared_list?
    true
  end

  class Scope < Scope
    def resolve
      user.admin? == true ? scope.all : scope.all.validated
    end
  end
end
