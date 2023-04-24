class Custom::DocumentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.admin? == true && ["alice@cookoon.fr", "a.fabre@basilic.com"].include?(user.email)
        scope.all
      else
        scope.none
      end
    end
  end
end
