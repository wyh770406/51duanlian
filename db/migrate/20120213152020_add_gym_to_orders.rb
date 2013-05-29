class AddGymToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :gym_id, :integer

    add_index :orders, :gym_id
  end
end
