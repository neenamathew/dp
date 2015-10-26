class Post < ActiveRecord::Base
  belongs_to :group
  has_many :comments,
    dependent:   :destroy

  validates :message, presence: true
  validates_length_of :message, :minimum => 1, :maximum => 1000, :allow_blank => false
  after_create :user_notification_action

  #notification  to all group_users when post is made in group
  def user_notification_action
    @group  = Group.find_by(id: group_id)
    @user = User.find(self.user_id)
    if @group.name == "public" then
      @user.followers.each do |user_follow|
        user_follow.notifications.new(message: "new post in #{@group.name} - #{message}").save
      end
    else
      @group.users.each do |user|
        if user.id != self.user_id
          user.notifications.new(message: "new post in #{@group.name} - #{message}").save
        end
      end
    end

  end
end
