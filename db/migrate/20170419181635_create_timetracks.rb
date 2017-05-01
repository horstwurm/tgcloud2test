class CreateTimetracks < ActiveRecord::Migration[5.0]
  def change
    create_table :timetracks do |t|
      t.integer :user_id
      t.integer :mobject_id
      t.string :activity
      t.float :amount
      t.date :datum

      t.timestamps
    end
  end
end
