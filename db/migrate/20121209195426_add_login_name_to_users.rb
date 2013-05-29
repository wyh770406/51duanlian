class AddLoginNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :login_name, :string

    add_index :users, :login_name
  end
end
