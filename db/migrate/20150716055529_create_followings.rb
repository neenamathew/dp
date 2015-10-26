class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.string :user_name
      t.string :email
      t.string :first_name

      t.timestamps null: false
    end
  end
end
