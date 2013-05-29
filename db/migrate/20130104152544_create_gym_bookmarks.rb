class CreateGymBookmarks < ActiveRecord::Migration
  def change
    create_table :gym_bookmarks, id: false do |t|
      t.integer :gym_id
      t.integer :user_id
    end

    add_index :gym_bookmarks, [:gym_id, :user_id]
  end
end
