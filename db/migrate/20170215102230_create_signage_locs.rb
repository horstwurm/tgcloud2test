class CreateSignageLocs < ActiveRecord::Migration[5.0]
  def change
    create_table :signage_locs do |t|
      t.string :name
      t.string :status
      t.boolean :public
      t.integer :owner_id
      t.string :owner_type
      t.string :geo_address
      t.string :address1
      t.string :address2
      t.string :address3
      t.integer :res_v
      t.integer :res_h

      t.timestamps
    end
  end
end
