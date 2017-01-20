class AddPasswordToPhoneApps < ActiveRecord::Migration[5.0]
  def change
    add_column :phone_apps,:password, :string
  end
end
