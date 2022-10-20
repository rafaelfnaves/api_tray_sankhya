class CreateCities < ActiveRecord::Migration[7.0]
  def change
    create_table :cities, id: :uuid do |t|
      t.string :name
      t.string :state
      t.integer :codcid
      t.integer :coduf
      t.integer :codmunfis
      t.integer :codmunsiafi

      t.timestamps
    end
  end
end
