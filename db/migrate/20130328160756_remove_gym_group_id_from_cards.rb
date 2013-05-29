class RemoveGymGroupIdFromCards < ActiveRecord::Migration
  def change
    remove_column :cards, :gym_group_id
  end
end
