class AddColumnNuNotaToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :nu_nota, :string
  end
end
