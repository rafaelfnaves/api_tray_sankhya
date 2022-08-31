class AddColumnIdTrayToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :id_tray, :string
  end
end
