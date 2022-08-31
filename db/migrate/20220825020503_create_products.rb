class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products, id: :uuid do |t|
      t.string :sku
      t.string :active
      t.float :price
      t.float :cost
      t.string :ncm
      t.string :name
      t.integer :stock
      t.string :brand
      t.integer :weight
      t.integer :height
      t.integer :width
      t.integer :length

      t.timestamps
    end
  end
end
