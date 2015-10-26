class AddNotificationTimeToUser < ActiveRecord::Migration
  def change
    add_column :users, :notification_time, :datetime
  end
end
