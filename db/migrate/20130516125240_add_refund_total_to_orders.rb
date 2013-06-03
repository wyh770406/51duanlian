class AddRefundTotalToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :refund_total, :decimal, :precision => 8, :scale => 2
  end
end
