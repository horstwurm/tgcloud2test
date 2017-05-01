class AddJahrMonatToPlanning < ActiveRecord::Migration[5.0]
  def change
    add_column :plannings, :jahrmonat, :string
  end
end
