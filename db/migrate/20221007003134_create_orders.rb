class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders, id: :uuid do |t|
      t.string :invoice
      t.string :date
      t.string :code_type_operation
      t.string :type_deal
      t.string :code_salesman
      t.string :code_company
      t.string :type_move
      t.references :customer, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
