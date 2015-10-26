class GroupPolicy < ApplicationPolicy

  def initialize(user,record)
    @user = user
    @record = record
  end

  def group_index?
    return true if @user.user_role.role.role_type == "admin"
    false
  end

  def group_show?
    return true if @user.user_role.role.role_type == "admin"
    false
  end

  def index?
    return true 
  end

  def edit?
    return true if @user.id == @record.user_id or @user.user_role.role.role_type == "admin"
    false
  end

  def update?
    return true if @user.id == @record.user_id or @user.user_role.role.role_type == "admin"
    false
  end

  def destroy?
    return true if @user.user_role.role.role_type == "admin" and @record.name != "public"
    return false if @record.name == "public" or  @user.id != @record.user_id
    true
  end

end
