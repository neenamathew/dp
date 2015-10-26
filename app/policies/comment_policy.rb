class CommentPolicy < ApplicationPolicy

  def initialize(user,record)
    @user = user
    @record = record
  end

  def create?
    return true if @user.groups.ids.include?Post.find(record.post_id).group_id
    false
  end

  def create_child?
    return true if @user.groups.ids.include?Post.find(record.post_id).group_id
    false
  end

  def destroy?
    return true if @user.id == @record.user_id
    false
  end

end
