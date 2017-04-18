class AddPilotToAppparams < ActiveRecord::Migration[5.0]
  def change
    add_column :appparams, :pilot, :boolean
  end
end
