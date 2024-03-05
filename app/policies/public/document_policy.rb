class Public::DocumentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.active
    end
  end
end
