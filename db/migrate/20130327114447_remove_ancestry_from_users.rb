class RemoveAncestryFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :ancestry
  end
end
