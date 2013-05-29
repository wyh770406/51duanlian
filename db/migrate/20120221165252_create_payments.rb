class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :order
      t.decimal :amount, :precision => 8, :scale => 2
      t.references :source, :polymorphic => true
      t.references :payment_method
      t.string :state

      t.timestamps
    end
    add_index :payments, :order_id
    add_index :payments, [:source_id, :source_type]
    add_index :payments, :payment_method_id
  end
end
