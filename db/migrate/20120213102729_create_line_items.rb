class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.integer :quantity
      t.decimal :price, :precision => 8, :scale => 2
      t.references :order
      t.references :purchasable, polymorphic: true

      t.timestamps
    end
    add_index :line_items, :order_id
    add_index :line_items, [:purchasable_id, :purchasable_type]
  end
end
