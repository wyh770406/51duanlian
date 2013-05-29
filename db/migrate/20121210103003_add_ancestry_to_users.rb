class AddAncestryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ancestry, :string
    add_index :users, :ancestry
  end
end
