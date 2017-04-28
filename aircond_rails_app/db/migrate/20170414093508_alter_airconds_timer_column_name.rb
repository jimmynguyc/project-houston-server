class AlterAircondsTimerColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :airconds,:timer,:timer_on
  end
end
