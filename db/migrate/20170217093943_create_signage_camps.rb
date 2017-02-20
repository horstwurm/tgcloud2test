class CreateSignageCamps < ActiveRecord::Migration[5.0]
  def change
    create_table :signage_camps do |t|
      t.integer :owner_id
      t.string :owner_type

      t.timestamps
    end
  end
end
