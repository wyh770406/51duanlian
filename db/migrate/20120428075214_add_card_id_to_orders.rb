class AddCardIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :card_id, :integer

    add_index :orders, :card_id
  end
end
