class ChangeColumnTimerInAirconds < ActiveRecord::Migration[5.0]
  def change
    change_column :airconds,:timer, :time, default:nil
  end
end
