class CreateGymGroupsGyms < ActiveRecord::Migration
  def change
    create_table :gym_groups_gyms, :id => false do |t|
      t.integer :gym_group_id
      t.integer :gym_id
    end

    add_index :gym_groups_gyms, [:gym_group_id, :gym_id]
  end
end
