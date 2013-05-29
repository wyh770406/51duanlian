class AddOrderIdToCardLineItems < ActiveRecord::Migration
  def change
    add_column :card_line_items, :order_id, :integer

    add_index :card_line_items, :order_id
  end
end
