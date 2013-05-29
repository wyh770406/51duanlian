class CreateGymsUsers < ActiveRecord::Migration
  def change
    create_table :gyms_users, id: false do |t|
      t.references :gym
      t.references :user
    end

    add_index :gyms_users, [:gym_id, :user_id]
  end
end
