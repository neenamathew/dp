class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :file_name
      t.string :content_type
      t.integer :user_id
      t.string :description
      t.binary :binary_data

      t.timestamps null: false
    end
  end
end
