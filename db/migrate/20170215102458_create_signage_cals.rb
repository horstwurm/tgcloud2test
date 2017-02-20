class CreateSignageCals < ActiveRecord::Migration[5.0]
  def change
    create_table :signage_cals do |t|
      t.integer :signage_loc_id
      t.integer :signage_id
      t.date :date_from
      t.date :date_to
      t.integer :time_from
      t.integer :time_to

      t.timestamps
    end
  end
end
