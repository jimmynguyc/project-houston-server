class CreateAircondStates < ActiveRecord::Migration[5.0]
  def change
    create_table :aircond_states do |t|
    	t.integer	:status
    	t.integer	:mode
    	t.integer	:fan_speed
    	t.integer :temperature
    	t.string	:ir_signal
      t.timestamps
    end
  end
end
