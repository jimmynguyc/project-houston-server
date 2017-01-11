class AddUsernameToPhoneApps < ActiveRecord::Migration[5.0]
  def change
		add_column :phone_apps,:user_name, :string
  end
end
