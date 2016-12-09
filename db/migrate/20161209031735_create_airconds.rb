class CreateAirconds < ActiveRecord::Migration[5.0]
  def change
    create_table :airconds do |t|
    	t.belongs_to :device
      t.belongs_to  :state
      t.integer :status, default: 2
      t.integer :mode
      t.integer :fan_speed
      t.integer :temperature
      t.timestamps
    end
  end
end
