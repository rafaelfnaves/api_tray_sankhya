class AddColumnProductIdTrayToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :product_id_tray, :string
  end
end
