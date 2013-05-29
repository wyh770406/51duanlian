class AddGymGroupIdToCardTypes < ActiveRecord::Migration
  def change
    add_column :card_types, :gym_group_id, :integer
    add_index :card_types, :gym_group_id
    remove_index :card_types, :gym_id
    remove_column :card_types, :gym_id
  end
end
