class ChangeTimezoneColumnForUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :timezone
  end
end
