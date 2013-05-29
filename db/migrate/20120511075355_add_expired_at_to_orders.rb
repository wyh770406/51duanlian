class AddExpiredAtToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :expired_at, :datetime
    
    add_index :orders, :expired_at
  end
end
