class AddColumnTimerOffToAirconds < ActiveRecord::Migration[5.0]
  def change
    add_column :airconds, :timer_off, :time
  end
end
