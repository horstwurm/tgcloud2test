class AddJahrmonatToTimetracks < ActiveRecord::Migration[5.0]
  def change
    add_column :timetracks, :jahrmonat, :string
  end
end
