class RelationshipPolicy < ApplicationPolicy

  def initialize(user,record)
    @user = user
    @record = record
  end

  def new?
   return true if @user.id == record.follower_id
   false
  end

end
