class Public::DocumentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.validated
    end
  end
end
