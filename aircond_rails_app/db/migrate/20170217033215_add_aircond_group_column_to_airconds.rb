class AddAircondGroupColumnToAirconds < ActiveRecord::Migration[5.0]
  def change
    add_column :airconds,:aircond_group_id, :integer
  end
end
