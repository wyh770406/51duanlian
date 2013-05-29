class AddGymGroupIdToCardCharges < ActiveRecord::Migration
  def change
    add_column :card_charges, :gym_group_id, :integer
    add_index :card_charges, :gym_group_id
    remove_index :card_charges, :gym_id
    remove_column :card_charges, :gym_id
  end
end
