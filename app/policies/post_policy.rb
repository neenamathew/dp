class PostPolicy < ApplicationPolicy

  def initialize(user,record)
    @user = user
    @record = record
  end

  def create?
    (@user.groups.ids.include?record.group_id)
  end

  def destroy?
    return true if @user.id == @record.user_id
    false
  end

end
