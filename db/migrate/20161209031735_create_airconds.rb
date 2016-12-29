class CreateAirconds < ActiveRecord::Migration[5.0]
  def change
    create_table :airconds do |t|
    	t.integer :device_id, index:true
      t.integer  :aircond_state_id, index:true
      t.integer :status, default: 2
      t.integer :mode
      t.integer :fan_speed
      t.integer :temperature
      t.time    :timer, default: Time.new(0)
      t.string  :alias
      t.timestamps
    end
  end
end
