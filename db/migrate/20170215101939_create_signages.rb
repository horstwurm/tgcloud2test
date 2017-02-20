class CreateSignages < ActiveRecord::Migration[5.0]
  def change
    create_table :signages do |t|
      t.integer :owner_id
      t.string :owner_type
      t.string :status
      t.string :header
      t.text :description
      t.string :avatar_file_name
      t.string :avatar_content_type
      t.integer :avatar_file_size
      t.datetime :avatar_updated_at

      t.timestamps
    end
  end
end
