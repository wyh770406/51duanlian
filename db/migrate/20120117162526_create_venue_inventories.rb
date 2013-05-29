class CreateVenueInventories < ActiveRecord::Migration
  def change
    create_table :venue_inventories do |t|
      t.integer :capacity
      t.references :gym
      t.references :venue_type

      t.timestamps
    end
    add_index :venue_inventories, :gym_id
    add_index :venue_inventories, :venue_type_id
  end
end
