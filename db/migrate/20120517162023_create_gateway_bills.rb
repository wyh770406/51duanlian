class CreateGatewayBills < ActiveRecord::Migration
  def change
    create_table :gateway_bills do |t|
      t.string :notification_id
      t.boolean :successful
      t.string :trade_state
      t.string :trade_number
      t.datetime :notified_at
      t.string :customer

      t.timestamps
    end
    add_index :gateway_bills, :notification_id
  end
end
