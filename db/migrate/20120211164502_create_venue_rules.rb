class CreateVenueRules < ActiveRecord::Migration
  def change
    create_table :venue_rules do |t|
      t.string :type
      t.references :activity
      t.text :settings

      t.timestamps
    end
    add_index :venue_rules, :activity_id
  end
end
