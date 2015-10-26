class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  has_one :user_role
  has_one :user, through: :user_role

  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :notifications
  has_many :photos
  mount_uploader :image, ImageUploader

  validates :first_name, presence: true
  validates_length_of :first_name, :minimum => 3, :maximum => 15, :allow_blank => false
  validates :last_name, presence: true
  validates_uniqueness_of :user_name
  validates_length_of :user_name, :minimum => 6, :maximum => 25, :allow_blank => false
  validates :last_name, presence: true
  validates_length_of :last_name, :minimum => 1, :maximum => 15, :allow_blank => false

  has_many :active_relationships, class_name:  "Relationship",
    foreign_key: "follower_id",
    dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
    foreign_key: "followed_id",
    dependent:   :destroy

  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  before_destroy :user_destroy_action
  before_validation :strip_whitespace

  def strip_whitespace
    self.user_name = self.user_name.strip
    self.first_name = self.first_name.strip
  end

  #user is destroyed - user group,posts and commetns will be deleted
  def user_destroy_action
    user = User.find(id)
    groups.each do |group|
      if group.user_id == id
        group.destroy
      end
    end
    user.groups.each do|group|
      group.posts.each do |post|
        if post.user_id == id
          post.destroy
        end
        post.comments.each do|comment|
          if comment.user_id == id
            comment.destroy
          end
        end
      end
    end
  end

  def self.search(search)
    admin_ids = Role.find_by(role_type: "admin").user_roles.collect(&:user_id)
    if search
      search = search.downcase.strip
      where('LOWER(first_name) LIKE ? AND (id) NOT IN (?) ', "%#{search}%",  admin_ids)
    else
      where('(id) NOT IN (?)', admin_ids)
    end
  end

end
