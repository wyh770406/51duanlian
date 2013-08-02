class CreateVenueMessage < ActiveRecord::Migration
  def change
    create_table :venue_messages do |t|
      t.references :gym
      t.string :mobile
      t.timestamps
    end
    add_index :venue_messages, :gym_id
  end
end
