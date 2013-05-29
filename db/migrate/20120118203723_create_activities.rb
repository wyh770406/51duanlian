class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.text :description
      t.integer :quantity
      t.date :available_from
      t.date :available_to
      t.datetime :open_at
      t.datetime :close_at
      t.string :display_on
      t.boolean :active
      t.references :gym
      t.references :venue_type

      t.timestamps
    end
    add_index :activities, :gym_id
    add_index :activities, :venue_type_id
  end
end
