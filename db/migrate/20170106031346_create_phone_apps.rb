class CreatePhoneApps < ActiveRecord::Migration[5.0]
  def change
    create_table :phone_apps do |t|
    	t.belongs_to :user
    	t.string 	:access_token
      t.timestamps
    end
  end
end
