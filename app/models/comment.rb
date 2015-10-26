class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :parent, class_name: "Comment"
  has_many :children, class_name: "Comment", :foreign_key => "parent_id"

  validates :message, presence: true
  validates_length_of :message, :minimum => 1, :maximum => 1000, :allow_blank => false
  after_create :user_notification_action

  #notification  to all group_users when comment is made to post
  def user_notification_action
    post = Post.find_by(id: post_id)
    group  = Group.find_by(id: post.group_id)
    group.users.each do |user|
      if self.user_id != user.id
        user.notifications.new(message:" new comment - #{message} to post #{post.message} in  #{group.name}").save
      end
    end
  end


end
