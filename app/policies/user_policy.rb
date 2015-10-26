class UserPolicy < ApplicationPolicy

  def initialize(user,record)
    @user = user
    @record = record
  end

  def user_index?
    return true if @user.user_role.role.role_type == "admin"
    false
  end

  def index?
    return false if @user.user_role.role.role_type == "admin"
    true
  end

  def create?
    return true if @user.user_role.role.role_type == "admin"
    false
  end

  def edit?
    return true if @user.user_role.role.role_type == "admin" or @user.id == @record.id
    false
  end

  def update?
    return true if @user.user_role.role.role_type == "admin" or @user.id == @record.id
    false
  end

  def destroy?
    return false if @record.user_role.role.role_type == "admin" or @user.id == @record.id
    true
  end

  def update_profile_picture?
    return true if @user.id == @record.id
    false
  end

end
