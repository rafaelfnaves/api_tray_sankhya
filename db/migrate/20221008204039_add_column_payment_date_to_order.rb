class AddColumnPaymentDateToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :payment_date, :date
  end
end
