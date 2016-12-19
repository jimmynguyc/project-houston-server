class CreateInfraredSignals < ActiveRecord::Migration[5.0]
  def change
    create_table :infrared_signals do |t|
    	t.string	:command
    	t.string	:ir_signal_in_conf
      t.timestamps
    end
  end
end
