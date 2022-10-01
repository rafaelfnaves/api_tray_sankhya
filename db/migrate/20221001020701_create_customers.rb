class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers, id: :uuid do |t|
      t.string :cnpj
      t.string :id_tray
      t.string :name
      t.string :rg
      t.string :cpf
      t.string :phone
      t.string :cellphone
      t.string :email
      t.string :token
      t.string :company_name
      t.string :state_inscription
      t.string :discount
      t.string :blocked_tray
      t.string :profile_customer_id
      t.string :address
      t.string :zip_code
      t.string :number_address
      t.string :complement
      t.string :neighborhood
      t.string :city
      t.string :state

      t.timestamps
    end
  end
end
