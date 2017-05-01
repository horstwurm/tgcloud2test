class AddParentToMobjects < ActiveRecord::Migration[5.0]
  def change
    add_column :mobjects, :parent, :integer
  end
end
