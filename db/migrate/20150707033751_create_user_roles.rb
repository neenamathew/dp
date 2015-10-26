class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.integer :role_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
