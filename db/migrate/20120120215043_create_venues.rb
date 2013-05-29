class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.datetime :start_at
      t.datetime :stop_at
      t.integer :count_on_hand
      t.references :activity

      t.timestamps
    end
    add_index :venues, :activity_id
  end
end
