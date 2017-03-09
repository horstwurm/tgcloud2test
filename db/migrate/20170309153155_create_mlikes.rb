class CreateMlikes < ActiveRecord::Migration[5.0]
  def change
    create_table :mlikes do |t|
      t.integer :user_id
      t.integer :mobject_id
      t.boolean :like

      t.timestamps
    end
  end
end
