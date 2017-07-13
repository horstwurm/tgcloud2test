class AddmkampagneToSignageHits < ActiveRecord::Migration[5.0]
  def change
    add_column :signage_hits, :mkampagne, :integer
    add_column :Signage_hits, :mstandort, :integer
    add_index :Signage_hits, :mkampagne
    add_index :Signage_hits, :mstandort
  end
end
