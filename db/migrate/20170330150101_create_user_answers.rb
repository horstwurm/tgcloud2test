class CreateUserAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :user_answers do |t|
      t.integer :answer_id
      t.integer :user_id
      t.float :num
      t.string :name
      t.boolean :checker
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
