class RemoveGymGroupIdFromGyms < ActiveRecord::Migration
  def change
    remove_column :gyms, :gym_group_id
  end
end
