class Relationship < ActiveRecord::Base

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, presence: true
  validates :followed_id, presence: true
  after_create :user_notification_action

  #notification  to user when relationship is made
  def user_notification_action
    user = User.find_by(id: followed_id)
    follower = User.find_by(id: follower_id)
    user.notifications.new(message:" #{follower.first_name} is now following you.").save
  end


end
