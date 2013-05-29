class AddGymGroupIdToGyms < ActiveRecord::Migration
  def change
    add_column :gyms, :gym_group_id, :integer
    add_index :gyms, :gym_group_id
  end
end
