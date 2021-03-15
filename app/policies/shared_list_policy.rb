class SharedListPolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  def add_contacts?
    record.user == user && record.initial?
  end

  class Scope < Scope
    def resolve
      scope.where(user: user).initial
    end
  end
end
