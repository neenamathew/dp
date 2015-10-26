class UserGroupPolicy < ApplicationPolicy

  def initialize(user,record)
    @user = user
    @record = record
  end

  def add_group_user?
    return true if @user.user_role.role.role_type == "admin" or Group.find(@record.group_id).user_id == @user.id
    false
  end

  def destroy?
    return true if  @user.user_role.role.role_type == "admin" and  @record.user_id != Group.find(@record.group_id).user_id
    return true if  @user.id == record.user_id  and Group.find(@record.group_id).user_id != @user.id and @user.user_role.role.role_type != "admin"
    return true if  Group.find(@record.group_id).user_id == @user.id and  @user.id != record.user_id
    false
  end

end
