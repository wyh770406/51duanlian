class RemoveGymGroupIdFromCardTypes < ActiveRecord::Migration
  def change
    remove_column :card_types, :gym_group_id
  end
end
