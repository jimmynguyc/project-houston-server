class CreateAirconds < ActiveRecord::Migration[5.0]
  def change
    create_table :airconds do |t|
    	t.belongs_to :device
      t.integer :status, default: 2
      t.integer :temperature
      t.integer :fan_speed
      t.integer	:mode
      t.string	:state
      t.timestamps
    end
  end
end
