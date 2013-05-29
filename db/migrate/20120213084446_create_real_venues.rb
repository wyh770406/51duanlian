class CreateRealVenues < ActiveRecord::Migration
  def change
    create_table :real_venues do |t|
      t.integer :count_on_hand
      t.integer :max_people
      t.references :venue

      t.timestamps
    end
    add_index :real_venues, :venue_id
  end
end
