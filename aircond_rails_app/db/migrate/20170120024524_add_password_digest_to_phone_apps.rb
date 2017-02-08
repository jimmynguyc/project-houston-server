class AddPasswordDigestToPhoneApps < ActiveRecord::Migration[5.0]
  def change
    add_column :phone_apps,:password_digest, :string
  end
end
