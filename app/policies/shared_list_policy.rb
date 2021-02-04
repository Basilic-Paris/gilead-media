class SharedListPolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  def add_contacts?
    record.user == user
  end

  def send_to_contacts?
    record.user == user
  end

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
end
