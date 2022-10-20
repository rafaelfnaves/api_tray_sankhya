class AddColumnCodeParSnkToCustomer < ActiveRecord::Migration[7.0]
  def change
    add_column :customers, :code_par_snk, :string
  end
end
