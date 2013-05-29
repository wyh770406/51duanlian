class AddAncestryToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :ancestry, :string
    add_index :activities, :ancestry
  end
end
