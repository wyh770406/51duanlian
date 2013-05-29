class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :number
      t.decimal :total, :precision => 8, :scale => 2
      t.string :state
      t.decimal :payment_total, :precision => 8, :scale => 2
      t.string :payment_state
      t.string :type
      t.references :user
      t.string :mobile
      t.string :verification_code
      t.text :special_instructions

      t.timestamps
    end
    add_index :orders, :user_id
    add_index :orders, :number
  end
end
