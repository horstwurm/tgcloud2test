class AddmkampagneToSignageCals < ActiveRecord::Migration[5.0]
  def change
    add_column :signage_cals, :mkampagne, :integer
    add_column :Signage_cals, :mstandort, :integer
    add_index :Signage_cals, :mkampagne
    add_index :Signage_cals, :mstandort
  end
end
