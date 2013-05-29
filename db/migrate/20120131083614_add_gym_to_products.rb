class AddGymToProducts < ActiveRecord::Migration
  def change
    add_column :products, :gym_id, :integer
    add_index :products, :gym_id
  end
end
