class RemoveColumns < ActiveRecord::Migration

  def self.up
    remove_column :users, :role_id
  end

end
