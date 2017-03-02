class CreateQrcodes < ActiveRecord::Migration[5.0]
  def change
    create_table :qrcodes do |t|
      t.integer :mobject_id
      t.string :mobject_type
      t.string :avatar_file_name
      t.string :avatar_content_type
      t.integer :avatar_file_size
      t.datetime :avatar_updated_at

      t.timestamps
    end
  end
end
