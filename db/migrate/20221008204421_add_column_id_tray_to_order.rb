class AddColumnIdTrayToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :id_tray, :string
  end
end
