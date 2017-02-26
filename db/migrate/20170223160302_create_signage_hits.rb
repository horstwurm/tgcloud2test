class CreateSignageHits < ActiveRecord::Migration[5.0]
  def change
    create_table :signage_hits do |t|
      t.integer :signage_camp_id
      t.integer :signage_loc_id
      t.datetime :datetime_from

      t.timestamps
    end
  end
end
