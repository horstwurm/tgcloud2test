class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.integer :mobject_id
      t.string :name
      t.text :description
      t.integer :sequence
      t.integer :mcategory_id

      t.timestamps
    end
  end
end
