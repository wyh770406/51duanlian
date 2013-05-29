class RemoveGymGroupIdFromCardCharges < ActiveRecord::Migration
  def change
    remove_column :card_charges, :gym_group_id
  end
end
