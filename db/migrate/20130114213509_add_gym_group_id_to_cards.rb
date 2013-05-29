class AddGymGroupIdToCards < ActiveRecord::Migration
  def change
    add_column :cards, :gym_group_id, :integer
    add_index :cards, :gym_group_id
    remove_index :cards, :gym_id
    remove_column :cards, :gym_id
  end
end
