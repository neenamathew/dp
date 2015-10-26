class Photo < ActiveRecord::Base
  belongs_to :user
  after_create :user_notification_action

  #notification  to user when profile picture is updated
  def user_notification_action
    @user = User.find_by(id: user_id)
    @user.following.each do |user|
      user.notifications.new(message:" #{@user.first_name} has changed profile picture.").save
    end
  end

  def image_file=(input_data)
    self.file_name = input_data.original_filename
    self.content_type = input_data.content_type.chomp
    self.binary_data = input_data.read
  end

end
