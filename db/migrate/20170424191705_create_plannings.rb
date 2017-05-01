class CreatePlannings < ActiveRecord::Migration[5.0]
  def change
    create_table :plannings do |t|
      t.integer :user_id
      t.integer :mobject_id
      t.string :period
      t.string :year
      t.string :month
      t.string :week
      t.string :day
      t.float :percentage

      t.timestamps
    end
  end
end
