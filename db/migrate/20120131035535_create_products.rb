class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.datetime :deleted_at
      t.integer :count_on_hand
      t.string :sku
      t.decimal :price, precision: 8, scale: 2

      t.timestamps
    end
  end
end
