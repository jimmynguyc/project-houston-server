class CreateDevices < ActiveRecord::Migration[5.0]
  def change
    create_table :devices do |t|
    	t.string	:url
    	t.string	:access_token
    	t.integer	:device_type
      t.timestamps
    end
  end
end
