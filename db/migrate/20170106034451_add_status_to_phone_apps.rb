class AddStatusToPhoneApps < ActiveRecord::Migration[5.0]
  def change
  	add_column :phone_apps,:status, :integer, default:0
  end
end
