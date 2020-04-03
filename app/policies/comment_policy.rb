class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def destroy?
    @record.user_id === @user.id
  end

  def update?
    @record.user_id === @user.id
  end
end
