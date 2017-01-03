class CreateParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :participants do |t|
      t.integer :user_id
      t.integer :mobject_id
      t.string :status

      t.timestamps
    end
  end
end
