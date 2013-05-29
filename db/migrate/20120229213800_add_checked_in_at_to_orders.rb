class AddCheckedInAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :checked_in_at, :datetime

    add_index :orders, :checked_in_at
  end
end
